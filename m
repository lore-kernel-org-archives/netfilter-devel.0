Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C54F3C1992;
	Wed,  8 Apr 2026 11:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649272; cv=none; b=o3q/IR5DiHazdEF91VTZIL5lB3xhyQFCUR30NwNLIXT8mdi2f4B1/ZOcgTk2c1MHz0Ov3z2Yr9AYsg9BDJsOfeF1gxJJy8+OASP45a3eOkIdKvWjulJCdI7cVhT4i4UoM7Z7wxUj4FoLz7rnJXCItZ2n7Er2vaKI3uZFrnHbcSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649272; c=relaxed/simple;
	bh=efxNzTSqI1QvLYqqvv6gR0CW8wLFKTsZf9UzQJz2oZs=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=L+xxnNS89dHQJPLML8j1M1C2FISpUtvJjTfLwabj2KJkvJLwi7sefI/zHkBHzb6Rwmh62vx9RC0lDYCngujYkeUDgT72MT1K9saMaiEIwfRtVbaJ7MqXSAtFXWMVY35wzQfscAagATO+ygeqTYQPuQndj3X2n1Sa2w2og2QRCSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMsU+yTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMsU+yTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3ABC19424;
	Wed,  8 Apr 2026 11:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649271;
	bh=efxNzTSqI1QvLYqqvv6gR0CW8wLFKTsZf9UzQJz2oZs=;
	h=Date:From:To:Cc:Subject:References:From;
	b=hMsU+yTjwOBVM5ofTn3qtOcoy5Li/qNXKaQGrQ05mznlTpAKoq/hU9j5yAixOfCBY
	 5Ulimf9LwPbw+jI+EV47OLO7IxAAGkCpV51YQsBOVmVjBbrKj8Pq2tHIvlElPKaEzf
	 teWw0wMFZ/oCVek/KaEWSNcafoBKG2FqzlZrr66pIQZESzbQNDEssrQuINOSaJCQep
	 GVnoKUoiaJgY9afkGcsAh4sk0G/aPb8A6UmKW9+GZgEptsY2dI6R9DsvKc5swHZ8Or
	 tjZC0mT9SkkYpRCqx4rv0A6peiJC3U3JBDeg5v/+2wasuuca42wMVg9Zj1AdyJc1NM
	 chmV1gw8Du9VQ==
Date: Wed, 08 Apr 2026 13:54:29 +0200
Message-ID: <20260408114952.604232981@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org,
 Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org,
 Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org
Subject: [patch V2 10/11] netfilter: xt_IDLETIMER: Switch to
 alarm_start_timer()
References: <20260408102356.783133335@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The existing alarm_start() interface is replaced with the new
alarm_start_timer() mechanism, which does not longer queue an already
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
+	if (!alarm_start_timer(&timer->alarm, timeout, true))
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
@@ -378,7 +390,7 @@ static int idletimer_tg_checkentry_v1(co
 			if (ktimespec.tv_sec > 0) {
 				pr_debug("time_expiry_remaining %lld\n",
 					 ktimespec.tv_sec);
-				alarm_start_relative(&info->timer->alarm, tout);
+				idletimer_start_alarm_ktime(info->timer, tout);
 			}
 		} else {
 				mod_timer(&info->timer->timer,

