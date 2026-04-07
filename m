Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7F39A7E5;
	Tue,  7 Apr 2026 08:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775552091; cv=none; b=n4fA6ubmxN5AwIPxILYTBy84FmnMJRierInFvV0AQwPeE99BfwpbGJlOA/fTtcXIPV2RExXScnincRtQXD16iE7G4seUjNWtERxFcol3QaGTqfEEbUzR9mkfg5c0pKCDUW8ft72M0UWNvxx8PKR6AjGSr8kpsJyg/R75B3atqs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775552091; c=relaxed/simple;
	bh=HVbYIByFSN+TWQMQtOO5s/XrlbdzeKGowXqhoZ1SPWU=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=hZQXmiFDS0AfbGm8fH5gl1kdtmN8/RT3TyvGs8vjyjJuCBoREb/9RH2GFP6GPctVTHLhcg4U9CSLzmW1Y/l0fHDU1Sko8DkYSUmwtExZ/w3y0eYantiQIQoRELVa7M1pdQP3x5oUmE4VqpNKAyBpyO33ZFREY5WkM3VfX1CjYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0+sjaJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0+sjaJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49B7C116C6;
	Tue,  7 Apr 2026 08:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775552091;
	bh=HVbYIByFSN+TWQMQtOO5s/XrlbdzeKGowXqhoZ1SPWU=;
	h=Date:From:To:Cc:Subject:References:From;
	b=B0+sjaJIuGE4mFMigwRoPUvZUWwbO5cH8Gdbg09DMFOnVTG0FQYDSTQHLNVCXdK3V
	 X7O+NDyKp+SaDBp730XnWN+59hG8wavraM+vUSg8bnAmLjFJjd0KnrE+R8aZ7SOSh3
	 +FPJKIEsg7lQehOafwPnpQvypqLZw4RelwCUHOcXB2U7YtKIxEgKcPeVVgJxOw7nRd
	 dHrwRPHNxLOXTuvAmvm4le081QJSzMJ54bfotCe/hQBkehWK4cyFt1iqt4sW3DNoFN
	 B2+lYl5z30N9T5m8C991EZPdLx1BrYZ+f8vLdcVmk4YAPdhSNX+OTxM3wvSow9vxeH
	 8yBNvJKIew7eQ==
Date: Tue, 07 Apr 2026 10:54:48 +0200
Message-ID: <20260407083247.965539525@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Calvin Owens <calvin@wbinvd.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 Ingo Molnar <mingo@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org,
 Sebastian Reichel <sre@kernel.org>,
 linux-pm@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Subject: [patch 07/12] alarmtimer: Provide alarmtimer_start()
References: <20260407083219.478203185@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Alarm timers utilize hrtimers for normal operation and only switch to the
RTC on suspend. In order to catch already expired timers early and without
going through a timer interrupt cycle, provide a new start function which
internally uses hrtimer_start_range_ns_user().

If hrtimer_start_range_ns_user() detects an already expired timer, it does
not queue it. In that case remove the timer from the alarm base as well.

Return the status queued or not back to the caller to handle the early
expiry.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: John Stultz <jstultz@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>
---
 include/linux/alarmtimer.h |    6 ++++++
 kernel/time/alarmtimer.c   |   28 ++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- a/include/linux/alarmtimer.h
+++ b/include/linux/alarmtimer.h
@@ -42,8 +42,14 @@ struct alarm {
 	void			*data;
 };
 
+static __always_inline ktime_t alarm_get_expires(struct alarm *alarm)
+{
+	return alarm->node.expires;
+}
+
 void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 		void (*function)(struct alarm *, ktime_t));
+bool alarmtimer_start(struct alarm *alarm, ktime_t expires, bool relative);
 void alarm_start(struct alarm *alarm, ktime_t start);
 void alarm_start_relative(struct alarm *alarm, ktime_t start);
 void alarm_restart(struct alarm *alarm);
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -365,6 +365,34 @@ void alarm_start_relative(struct alarm *
 }
 EXPORT_SYMBOL_GPL(alarm_start_relative);
 
+/**
+ * alarmtimer_start - Sets an alarm to fire
+ * @alarm:	Pointer to alarm to set
+ * @expires:	Expiry time
+ * @relative:	True if @expires is relative
+ *
+ * Returns: True if the alarm was queued. False if it already expired
+ */
+bool alarmtimer_start(struct alarm *alarm, ktime_t expires, bool relative)
+{
+	struct alarm_base *base = &alarm_bases[alarm->type];
+
+	if (relative)
+		expires = ktime_add_safe(expires, base->get_ktime());
+
+	trace_alarmtimer_start(alarm, base->get_ktime());
+
+	guard(spinlock_irqsave)(&base->lock);
+	alarm->node.expires = expires;
+	alarmtimer_enqueue(base, alarm);
+	if (!hrtimer_start_range_ns_user(&alarm->timer, expires, 0, HRTIMER_MODE_ABS)) {
+		alarmtimer_dequeue(base, alarm);
+		return false;
+	}
+	return true;
+}
+EXPORT_SYMBOL_GPL(alarmtimer_start);
+
 void alarm_restart(struct alarm *alarm)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];

