From: "Srinivasan, Suman (Suman)** CTR **"
	<suman.srinivasan@alcatel-lucent.com>
Subject: RE: Modifying packets in userspace using libnetfilter_queue / got
 it working
Date: Thu, 30 Jul 2009 15:46:28 -0500
Message-ID: <5BB67BF4A0D4544A918C2FD76487A1E13D894607@USNAVSXCHMBSB2.ndc.alcatel-lucent.com>
References: <5BB67BF4A0D4544A918C2FD76487A1E13D8944D6@USNAVSXCHMBSB2.ndc.alcatel-lucent.com>
 <1248966960.11586.30.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ihemail2.lucent.com ([135.245.0.35]:48892 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZG3Uqh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:46:37 -0400
In-Reply-To: <1248966960.11586.30.camel@khasse.inl.fr>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

Thanks a lot! This works! The Python code is able to modify packets, and it is so much easier to handle and manipulate TCP packets using Python, dpkt and the netfilter bindings in userspace.

> For testing, the easiest way is :
> http://software.inl.fr/trac/wiki/nfqueue-bindings

I installed the Python bindings on Ubuntu using:
sudo apt-get install nfqueue-bindings-python

pypcap and dpkt libraries for Python need to be installed to use it. pypcap can be installed using:
sudo apt-get install pypcap

The downloadable version of dpkt does not work with my version of Python, I had to check out the latest version using svn and build it.

> You can do Proof of Concept in Python, perl ... for an example of packet
> modification:
> http://git.inl.fr/cgi-bin/gitweb.cgi?p=nfqueue-
> bindings.git;a=blob;f=examples/rewrite.py;h=4086734e4483edd009f8333a1cc4d0
> 23a365a797;hb=HEAD

This code *almost* works. I had to modify the qf_bind() and qf_unbind() calls and remove the AF_INET which was being passed as an argument - the two functions worked after the arguments were removed. Perhaps the library has changed slightly.

> Yes you need to recompute manually all checksum and length and send
> decision with nfq_set_verdict providing pointer to modified data and
> data length to the function.

The sample code has code to change the length of the text - but it resets the checksum value to zero. Maybe the network layer regenerates the checksum? Anyway the sample code worked for me on a local network.

> To do short: ip_queue is deprecated and replaced by libnetfilter_queue.

Thanks,
Suman

--
Falun Gong: www.falundafa.org | www.faluninfo.net
Peaceful meditation faces persecution in China
