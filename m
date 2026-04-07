Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F553A1D1C;
	Tue,  7 Apr 2026 08:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552111; cv=none; b=Gdadrk4JjBmLDAefq0kdHIjxddzn2glBjnL5jPmp1PTQLAKs0DCFpF0KIanMWVM8hVkZ+gsUKWaq0NpGDKKKhk/uL4jc7IeceEjAjf5B4fdFT2yY4OcvOtMrQpXOOWOMSHJKSjrsFCU2qY7sbpf3smqIh+zc901+EJFHWU1NpAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552111; c=relaxed/simple;
	bh=UWMCyKMLfyWDIafgwUqZJttuFVA66S79Y0i2Q6zCV8M=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=touDF2OcvCJmhg6zbEjVuDBHiv6TC22vNQ/YUZ6kCTdEWWGErS+JDNkQHANfEdxSMiRnZdhwfRmckwoA40RcTk5jHhgg/zq6SpfLN0BekH+L6BQdE8w73xcB9exE2S+ajTdYM8NwMdoF0+xFUkKARHJFLwSplNYFardKqc+GetU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MnRZgvEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnRZgvEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD27C116C6;
	Tue,  7 Apr 2026 08:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552111;
	bh=UWMCyKMLfyWDIafgwUqZJttuFVA66S79Y0i2Q6zCV8M=;
	h=Date:From:To:Cc:Subject:References:From;
	b=MnRZgvEh1K64MnDUiej8C6cmHlWfJkZ1Eu1rQlC7tXO1zvRibsLF+aem+XObc8Xmd
	 Tl5p7LFvyPPgk6KKR0zXEGtHrS7lutk0yPYwc89EHFt34lW4piFp/RpDRANLJC7q4d
	 N0d9V7eR0ao4ZvNmSWplIzPU9xlojU+cB1o0io4uSKL69mnndeOllpApjvNfuzmNhc
	 uXa93Fc1kXL4Myf0iTPzoCcuRJi2L0wu/laCvqcgVPoideK9mmH+ogTanmz+ovP1mA
	 /JZqsFNoKIarAT939bBbE9Z5CpDtAVfej49qGk3KjjO8DQh8poDxKkChXe6KjeFTuT
	 84RuxSWAE2LIA==
Date: Tue, 07 Apr 2026 10:55:08 +0200
Message-ID: <20260407083248.236423400@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org,
 Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Ingo Molnar <mingo@kernel.org>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org,
 Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org
Subject: [patch 11/12] netfilter: xt_IDLETIMER: Switch to alarmtimer_start()
References: <20260407083219.478203185@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The existing alarm-start() interface is replaced with the new
alarmtimer_start() mechanism, which does not longer queue an already
expired timer and returns the state.

Adjust the code to utilize this so it schedules the work in the case that
the timer was already expired. Unlikely to happen as the timeout is at
least a second, but not impossible especially with virtualization.

No functional change intended

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
---
 net/netfilter/xt_IDLETIMER.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -115,6 +115,21 @@ static void idletimer_tg_alarmproc(struc
 	schedule_work(&timer->work);
 }
 
+static void idletimer_start_alarm_ktime(struct idletimer_tg *timer, ktime_t timeout)
+{
+	/*
+	 * The timer should always be queued as @tout it should be least one
+	 * second, but handle it correctly in any case. Virt will manage!
+	 */
+	if (!alarmtimer_start(&timer->alarm, timeout, true))
+		schedule_work(&timer->work);
+}
+
+static void idletimer_start_alarm_sec(struct idletimer_tg *timer, unsigned int seconds)
+{
+	idletimer_start_alarm_ktime(timer, ktime_set(seconds, 0));
+}
+
 static int idletimer_check_sysfs_name(const char *name, unsigned int size)
 {
 	int ret;
@@ -220,12 +235,10 @@ static int idletimer_tg_create_v1(struct
 	INIT_WORK(&info->timer->work, idletimer_tg_work);
 
 	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
-		ktime_t tout;
 		alarm_init(&info->timer->alarm, ALARM_BOOTTIME,
 			   idletimer_tg_alarmproc);
 		info->timer->alarm.data = info->timer;
-		tout = ktime_set(info->timeout, 0);
-		alarm_start_relative(&info->timer->alarm, tout);
+		idletimer_start_alarm_sec(info->timer, info->timeout);
 	} else {
 		timer_setup(&info->timer->timer, idletimer_tg_expired, 0);
 		mod_timer(&info->timer->timer,
@@ -271,8 +284,7 @@ static unsigned int idletimer_tg_target_
 		 info->label, info->timeout);
 
 	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
-		ktime_t tout = ktime_set(info->timeout, 0);
-		alarm_start_relative(&info->timer->alarm, tout);
+		idletimer_start_alarm_sec(info->timer, info->timeout);
 	} else {
 		mod_timer(&info->timer->timer,
 				secs_to_jiffies(info->timeout) + jiffies);
@@ -384,7 +396,7 @@ static int idletimer_tg_checkentry_v1(co
 			if (ktimespec.tv_sec > 0) {
 				pr_debug("time_expiry_remaining %lld\n",
 					 ktimespec.tv_sec);
-				alarm_start_relative(&info->timer->alarm, tout);
+				idletimer_start_alarm_ktime(info->timer, tout);
 			}
 		} else {
 				mod_timer(&info->timer->timer,

