From: Justin Yaple <yaplej@gmail.com>
Subject: exit netfilter queue processing
Date: Sun, 5 Dec 2010 18:05:39 -0800
Message-ID: <AANLkTimyUqtT=dNFvgjyrsWWnDQQ6xRHmkSF0z7aLuSn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48631 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0LFCFl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:05:41 -0500
Received: by wyb28 with SMTP id 28so11536322wyb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Dec 2010 18:05:40 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I used the netfilter queue example for processing packets but one
thing that I could not find is how to safely stop everything.  I setup
some sig handlers to try and be a little more graceful in terminating
with CTRL+C or when my service is stopped.  My problem is that recv()
blocks so if there are no packets in the queue my servicestate might
be changed to STOPPED and there might not be any more packets in the
queue so it will wait indefinitely for recv().

I have been reading Linux System Programming and I think that a
select() around the recv() might do the trick but didnt know if there
was some other way to do this specific to netfilter.  Maybe something
that would force recv() to return with a value of rv < 0.

while ((servicestate >= STOPPING) && ((rv = recv(fd, buf, sizeof(buf),
0)) && rv >= 0)) {
        /*
         * This will execute the callback_function for each ip packet
         * that is received into the Netfilter QUEUE.
         */
        nfq_handle_packet(h, buf, rv);
}

Thanks.
