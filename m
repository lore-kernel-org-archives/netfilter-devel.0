Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CD61CAB0
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2023 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jEZH8++/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m3MgzanwP77R8TtVxTVWAjgCdJzHSFSuryhAMzazhyA=; b=jEZH8++/t2ILEDnXnNZ6krf55k
	ZvT4BNlEiP9NhZcKFKaA6x+a06rKuTKD4SMJs4A0HYkTXerE9mwrHcxEpSpgj5hAWhwLbiq9u3Brm
	GE6LFpBiTEdgsmYtbz2wh6yy8chcrbcfPnX+onSV6I9SPMyQ90D/jOuUJyMcMYoc38ItEi80ciuvM
	PZWvDG8O2Lbo30g+79wafKjzQ2qVMUMiiDBK4VhFVmr1kPZbosIM8guc4I5zd9LwmSsnFAbHBpKRm
	NIqtNb7ZrEL09utIVDedZhRlNsMIwhj4aO55a6pK9bDqnMkMnD4FSHkPFN/v5grX5VbE2djv6IzDg
	m2kytQ2A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFbns-0000yy-Ri; Tue, 19 Dec 2023 16:14:40 +0100
Date: Tue, 19 Dec 2023 16:14:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jethro Beekman <jethro@fortanix.com>, howardjohn@google.com,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
Subject: Re: [iptables PATCH] iptables-legacy: Fix for mandatory lock waiting
Message-ID: <ZYGzYIvBE+v6J73m@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	Jethro Beekman <jethro@fortanix.com>, howardjohn@google.com,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>
References: <20231219020855.4794-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219020855.4794-1-phil@nwl.cc>

On Tue, Dec 19, 2023 at 03:08:55AM +0100, Phil Sutter wrote:
> Parameter 'wait' passed to xtables_lock() signals three modes of
> operation, depending on its value:
> 
> -1: --wait not specified, do not wait if lock is busy
>  0: --wait specified without value, wait indefinitely until lock becomes
>     free

These two are actually the other way round: 'wait' is zero if no '-w'
was specified and -1 if given without timeout. Sorry for the confusion!

> >0: Wait for 'wait' seconds for lock to become free, abort otherwise
> 
> Since fixed commit, the first two cases were treated the same apart from
> calling alarm(0), but that is a nop if no alarm is pending. Fix the code
> by requesting a non-blocking flock() in the second case. While at it,
> restrict the alarm setup to the third case only.
> 
> Cc: Jethro Beekman <jethro@fortanix.com>
> Cc: howardjohn@google.com
> Cc: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1728
> Fixes: 07e2107ef0cbc ("xshared: Implement xtables lock timeout using signals")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  .../shell/testcases/iptables/0010-wait_0      | 55 +++++++++++++++++++
>  iptables/xshared.c                            |  4 +-
>  2 files changed, 57 insertions(+), 2 deletions(-)
>  create mode 100755 iptables/tests/shell/testcases/iptables/0010-wait_0
> 
> diff --git a/iptables/tests/shell/testcases/iptables/0010-wait_0 b/iptables/tests/shell/testcases/iptables/0010-wait_0
> new file mode 100755
> index 0000000000000..4481f966ce435
> --- /dev/null
> +++ b/iptables/tests/shell/testcases/iptables/0010-wait_0
> @@ -0,0 +1,55 @@
> +#!/bin/bash
> +
> +case "$XT_MULTI" in
> +*xtables-legacy-multi)
> +	;;
> +*)
> +	echo skip $XT_MULTI
> +	exit 0
> +	;;
> +esac
> +
> +coproc RESTORE { $XT_MULTI iptables-restore; }
> +echo "*filter" >&${RESTORE[1]}
> +
> +
> +$XT_MULTI iptables -A FORWARD -j ACCEPT &
> +ipt_pid=$!
> +
> +waitpid -t 1 $ipt_pid
> +[[ $? -eq 3 ]] && {
> +	echo "process waits when it should not"
> +	exit 1
> +}
> +wait $ipt_pid
> +[[ $? -eq 0 ]] && {
> +	echo "process exited 0 despite busy lock"
> +	exit 1
> +}
> +
> +t0=$(date +%s)
> +$XT_MULTI iptables -w 3 -A FORWARD -j ACCEPT
> +t1=$(date +%s)
> +[[ $((t1 - t0)) -ge 3 ]] || {
> +	echo "wait time not expired"
> +	exit 1
> +}
> +
> +$XT_MULTI iptables -w -A FORWARD -j ACCEPT &
> +ipt_pid=$!
> +
> +waitpid -t 3 $ipt_pid
> +[[ $? -eq 3 ]] || {
> +	echo "no indefinite wait"
> +	exit 1
> +}
> +kill $ipt_pid
> +waitpid -t 3 $ipt_pid
> +[[ $? -eq 3 ]] && {
> +	echo "killed waiting iptables call did not exit in time"
> +	exit 1
> +}
> +
> +kill $RESTORE_PID
> +wait
> +exit 0
> diff --git a/iptables/xshared.c b/iptables/xshared.c
> index 5cae62b45cdf4..43fa929df7676 100644
> --- a/iptables/xshared.c
> +++ b/iptables/xshared.c
> @@ -270,7 +270,7 @@ static int xtables_lock(int wait)
>  		return XT_LOCK_FAILED;
>  	}
>  
> -	if (wait != -1) {
> +	if (wait > 0) {
>  		sigact_alarm.sa_handler = alarm_ignore;
>  		sigact_alarm.sa_flags = SA_RESETHAND;
>  		sigemptyset(&sigact_alarm.sa_mask);
> @@ -278,7 +278,7 @@ static int xtables_lock(int wait)
>  		alarm(wait);
>  	}
>  
> -	if (flock(fd, LOCK_EX) == 0)
> +	if (flock(fd, LOCK_EX | (wait ? 0 : LOCK_NB)) == 0)
>  		return fd;
>  
>  	if (errno == EINTR) {
> -- 
> 2.43.0
> 
> 
> 
