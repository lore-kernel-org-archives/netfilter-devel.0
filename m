Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iLYBry7y"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0307CD64
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 11:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701112650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZFmramrFei42st2jNaMzjuE1PsX3Lw6Ue59VRQ9XEs=;
	b=iLYBry7y4hhCcBbuoMkMn+smKriWykTH2abIJHccGPdC/HHndj+SEJt/k9pziJG+KJohCM
	3lH+HJ6158h5DEOiqddIL7q/Mep3eFa5+7zEgWnZJK1z3oCoQX590wowUU5lb0DYlGAynK
	tO2wGsr8Bv/J9E5bygxlGC/+31qlVuA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-mqnkhjXAOfmcZRR0YmBKpQ-1; Mon, 27 Nov 2023 14:17:26 -0500
X-MC-Unique: mqnkhjXAOfmcZRR0YmBKpQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3958872503
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Nov 2023 19:17:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.43])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E93C1121307;
	Mon, 27 Nov 2023 19:17:24 +0000 (UTC)
From: Thomas Haller <thaller@redhat.com>
To: NetFilter <netfilter-devel@vger.kernel.org>
Cc: Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: workaround lack of `wait -p` before bash 5.1
Date: Mon, 27 Nov 2023 20:15:35 +0100
Message-ID: <20231127191713.3528973-2-thaller@redhat.com>
In-Reply-To: <20231127191713.3528973-1-thaller@redhat.com>
References: <20231127191713.3528973-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Before bash 5.1, `wait -p` is not supported. So we cannot know which
child process completed.

As workaround, explicitly wait for the next PID. That works, but it
significantly reduces parallel execution, because a long running job
blocks the queue.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/run-tests.sh | 47 ++++++++++++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
index 3cde97b7ea17..f1345bb14e7c 100755
--- a/tests/shell/run-tests.sh
+++ b/tests/shell/run-tests.sh
@@ -30,6 +30,23 @@ array_contains() {
 	return 1
 }
 
+array_remove_first() {
+	local _varname="$1"
+	local _needle="$2"
+	local _result=()
+	local _a
+
+	eval "local _input=( \"\${$_varname[@]}\" )"
+	for _a in "${_input[@]}" ; do
+		if [ -n "${_needle+x}" -a "$_needle" = "$_a" ] ; then
+			unset _needle
+		else
+			_result+=("$_a")
+		fi
+	done
+	eval "$_varname="'( "${_result[@]}" )'
+}
+
 colorize_keywords() {
 	local out_variable="$1"
 	local color="$2"
@@ -598,13 +615,14 @@ if [ ! -x "$DIFF" ] ; then
 	DIFF=true
 fi
 
+JOBS_PIDLIST_ARR=()
 declare -A JOBS_PIDLIST
 
 _NFT_TEST_VALGRIND_VGDB_PREFIX=
 
 cleanup_on_exit() {
 	pids_search=''
-	for pid in "${!JOBS_PIDLIST[@]}" ; do
+	for pid in "${JOBS_PIDLIST_ARR[@]}" ; do
 		kill -- "-$pid" &>/dev/null
 		pids_search="$pids_search\\|\\<$pid\\>"
 	done
@@ -858,17 +876,33 @@ job_start() {
 	return "$rc_got"
 }
 
+# `wait -p` is only supported since bash 5.1
+WAIT_SUPPORTS_P=1
+[ "${BASH_VERSINFO[0]}" -le 4 -o \( "${BASH_VERSINFO[0]}" -eq 5 -a "${BASH_VERSINFO[1]}" -eq 0 \) ] && WAIT_SUPPORTS_P=0
+
 job_wait()
 {
 	local num_jobs="$1"
+	local JOBCOMPLETED
+	local rc_got
+
+	while [ "${#JOBS_PIDLIST_ARR[@]}" -gt 0 -a "${#JOBS_PIDLIST_ARR[@]}" -ge "$num_jobs" ] ; do
+		if [ "$WAIT_SUPPORTS_P" = 1 ] ; then
+			wait -n -p JOBCOMPLETED
+			rc_got="$?"
+			array_remove_first JOBS_PIDLIST_ARR "$JOBCOMPLETED"
+		else
+			# Without `wait -p` support, we need to explicitly wait
+			# for a PID. That reduces parallelism.
+			JOBCOMPLETED="${JOBS_PIDLIST_ARR[0]}"
+			JOBS_PIDLIST_ARR=( "${JOBS_PIDLIST_ARR[@]:1}" )
+			wait -n "$JOBCOMPLETED"
+			rc_got="$?"
+		fi
 
-	while [ "$JOBS_N_RUNNING" -gt 0 -a "$JOBS_N_RUNNING" -ge "$num_jobs" ] ; do
-		wait -n -p JOBCOMPLETED
-		local rc_got="$?"
 		local testfile2="${JOBS_PIDLIST[$JOBCOMPLETED]}"
 		unset JOBS_PIDLIST[$JOBCOMPLETED]
 		print_test_result "${JOBS_TEMPDIR["$testfile2"]}" "$testfile2" "$rc_got"
-		((JOBS_N_RUNNING--))
 		check_kmemleak
 	done
 }
@@ -878,7 +912,6 @@ if [ "$NFT_TEST_SHUFFLE_TESTS" = y ] ; then
 fi
 
 TESTIDX=0
-JOBS_N_RUNNING=0
 for testfile in "${TESTS[@]}" ; do
 	job_wait "$NFT_TEST_JOBS"
 
@@ -897,7 +930,7 @@ for testfile in "${TESTS[@]}" ; do
 	pid=$!
 	eval "$set_old_state"
 	JOBS_PIDLIST[$pid]="$testfile"
-	((JOBS_N_RUNNING++))
+	JOBS_PIDLIST_ARR+=( "$pid" )
 done
 
 job_wait 0
-- 
2.43.0

