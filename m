Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316A1DFF8
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723557686; cv=none; b=WpcoLhOIG7mi7v691hrStMln6+eehdLc7hnCaG2xtr0de2YXd/DpMQD/VCz8bLW7MwBpBZH+I6eyjJc3Vf6K/Fy989E5YFEvbfBKtMJ5USbdQ29AWPlsJ0zVkbR1oAPOZNs9lSByl0GqlXJN2vjRm96iC6lu4Fq+x43hL9JNghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723557686; c=relaxed/simple;
	bh=CWigfKc67VnvdqYdY3HRNrYTA1Rhw3b5A8OWSx2+2dY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZYVHggD5aVZ549Id6YdAnJOb9kJ+izeHUKt6nm0X1IX0IOYBNbHsU9cFBppgunMxVwTcbYpBAV2UGU/Bdu7/kiboHg3I8HssAzEUv0GDjJt1ZbPu8Uptb5nKbbVxgULTEvlO6wufWM702oDRb1NY1/perW/rXHJw4u8teLUmmJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=11LklOSs; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PE1OkRZI; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="11LklOSs";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PE1OkRZI"
Date: Tue, 13 Aug 2024 16:01:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723557682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=sdPc+FcGOPA+PuIhNA7NgJi0zcrR2V3KbWTEaYJLn8o=;
	b=11LklOSsmwvaQcgnn5IINIVbbndNq+jreIcy66YIkE8F8AYKwf5a4WqOv8K65qOgzo6sa4
	zWEhGkmumHkYCyNTYDa4kdqI4xQ3mrjTQ6zLRKvAXiiXpfK031ZmozMaGXelbd5PAX1+Y9
	GuM0Iy2EZDv5mvxPCsax1fqsVGtQHa5FzVdKeey6zBeK80E/pNmOxshX+afjTVFtdMzZ3U
	kETUpPLxTIeHn925wTBIxYq1OOeOxrM5cLcqrO/YvG72RrlR28wAvs+LgC3i7YkhYnChpj
	Ht0HtCZVU9y1wGNRW2YrgmU7hxukDSYRIzu3t9jQ533E0lbaCFfilH1NvF0woA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723557683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=sdPc+FcGOPA+PuIhNA7NgJi0zcrR2V3KbWTEaYJLn8o=;
	b=PE1OkRZIS2JypLA/xwoHMo6Oyx7ON1oENWVF/TaOab7KFQ/Fm6bI2brV8TiaG3ZvbHyUuo
	af2a69hEqeXwckDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [Q] The usage of xt_recseq.
Message-ID: <20240813140121.QvV8fMbm@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

xt_recseq is per-CPU sequence counter which is not entirely using the
seqcount API.
The writer side of the sequence counter is updating the packet and byte
counter (64bit) while processing a packet. The reader simply retrieves
the two counter.
Based on the code, the writer side can be recursive which is probably
why the "regular" write side isn't used or maybe because there is no
"lock".
The seqcount is per-CPU and disabling BH is used as the "lock". On
PREEMPT_RT code in local_bh_disable()ed section is preemptible and this
means that a seqcount reader with higher priority can preempt the writer
which leads to a deadlock. 

While trying to trigger the writer side, I managed only to trigger a
single reader and only while using iptables-legacy/ arptables-legacy
commands. The nft did not trigger it. So it is legacy code only.

Would it work to convert the counters to u64_stats_sync? On 32bit
there would be a seqcount_t with preemption disabling during the
update which means the xt_write_recseq_begin()/ xt_write_recseq_end()
has to be limited the counter update only. On 64bit architectures there
would be just the update. This means that number of packets and bytes
might be "off" (the one got updated, the other not "yet") but I don't
think that this is a problem here.

I could send a RFC patch if there is nothing obvious I overlooked ;)

Sebastian
