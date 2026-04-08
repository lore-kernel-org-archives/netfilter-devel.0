Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8AC3B8BBF;
	Wed,  8 Apr 2026 11:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775649255; cv=none; b=UB/KMr3b9mKHdxAlWOHcmn58SXp9Z+LJpXLGy8DIE8kW0lXamP8o4C0KcoPAHHC6gbR8M8d+wvY5BxVn7nSPx+SSmyW61+e8Rjh7TVJxNIxXy0288D8FTGZkj2LJv1brhIhG0cfPJ2E8AzuTKbTYIywm1GtPiWmAaZ14EQe2aWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775649255; c=relaxed/simple;
	bh=YIwK+oTFsr7FtmUMtD6jU5Zh3TOHfMdcCbzlxv+EOgE=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=m5dafwh9VSoMf2rIpEYduN3Mmh+36XVW1P5OHDIVeXv7ujo6EgyKU+/lcA0rzAjfUqCC84MmFNxkXoCcrmpr3KLNI9Lmr27NLBX98VvqEtvHgdx71Ont4BPdHzIhQf1aH4b1jUuSxCZDa4+DlrvugGdgRvGDUtEOqaGm/Rns4EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aUWORh8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aUWORh8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E01BC19421;
	Wed,  8 Apr 2026 11:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775649254;
	bh=YIwK+oTFsr7FtmUMtD6jU5Zh3TOHfMdcCbzlxv+EOgE=;
	h=Date:From:To:Cc:Subject:References:From;
	b=aUWORh8jnpJkqBZ9MPr6oE8wBea+vpybbs9uFZPPCfx8Vpea7tIT1P00holD6vWH0
	 peVGZhybxP3x+wMR/JvxURC3ttXcr+cX55L/4BIT9yXbT2kSl0PhuV3wZGhLFL7eZJ
	 eI3+O8Ifs2YcjXRdhr6nzvt9IWFY/4Hxur+RKhlOiZ5fvMq2JjwxsHj14cFqG9ahbc
	 eqbSPFIgLVzOGfAHjOweyNGoIElXybHrmqBZXa9dQnLOzky3tuWD8PhrxV45rajp12
	 tGvZJaMJUOEyhQl+v7uRerhkfjy2yDO/ZX3P9ApQyJNk9wRsHyBBR3XADXRsjzObu3
	 louz+F6zsTisg==
Date: Wed, 08 Apr 2026 13:54:11 +0200
Message-ID: <20260408114952.332822525@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <jstultz@google.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Calvin Owens <calvin@wbinvd.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
Subject: [patch V2 06/11] alarmtimer: Provide alarm_start_timer()
References: <20260408102356.783133335@kernel.org>
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
Acked-by: John Stultz <jstultz@google.com>
Cc: Stephen Boyd <sboyd@kernel.org>
---
V2: Rename to alarm_start_timer() - Peter
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
+bool alarm_start_timer(struct alarm *alarm, ktime_t expires, bool relative);
 void alarm_start(struct alarm *alarm, ktime_t start);
 void alarm_start_relative(struct alarm *alarm, ktime_t start);
 void alarm_restart(struct alarm *alarm);
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -365,6 +365,34 @@ void alarm_start_relative(struct alarm *
 }
 EXPORT_SYMBOL_GPL(alarm_start_relative);
 
+/**
+ * alarm_start_timer - Sets an alarm to fire
+ * @alarm:	Pointer to alarm to set
+ * @expires:	Expiry time
+ * @relative:	True if @expires is relative
+ *
+ * Returns: True if the alarm was queued. False if it already expired
+ */
+bool alarm_start_timer(struct alarm *alarm, ktime_t expires, bool relative)
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
+EXPORT_SYMBOL_GPL(alarm_start_timer);
+
 void alarm_restart(struct alarm *alarm)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];

