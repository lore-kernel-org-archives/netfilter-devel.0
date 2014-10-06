From: =?UTF-8?B?c3TDqXBoYW5lIGJyeWFudA==?= <stephane.ml.bryant@gmail.com>
Subject: queuing to userspace for the bridge family, using nftables
Date: Mon, 06 Oct 2014 19:26:42 +0200
Message-ID: <5432D0D2.5050905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp7.inforoutes.fr ([46.18.231.36]:52718 "EHLO
	smtp7.inforoutes.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaJFRqG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:46:06 -0400
Received: [from localhost (localhost.localdomain [127.0.0.1])
                        by smtp7.inforoutes.fr  with ESMTP id s96HQwOM017379
                        for <netfilter-devel@vger.kernel.org>; Mon, 6 Oct 2014 19:26:58 +0200]
Received: from smtp7.inforoutes.fr ([127.0.0.1])
	by localhost (smtp7.inforoutes.fr [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id rMDAz1X+-gr6 for <netfilter-devel@vger.kernel.org>;
	Mon,  6 Oct 2014 19:26:49 +0200 (CEST)
Received: from vm02.inforoutes.fr (vm02.inforoutes.fr [46.18.231.96])
	by smtp7.inforoutes.fr  with ESMTP id s96HQn8F017357
	for <netfilter-devel@vger.kernel.org>; Mon, 6 Oct 2014 19:26:49 +0200
Received: from [192.168.2.102] (gar13-9-83-156-136-174.fbx.proxad.net [83.156.136.174])
	(authenticated bits=0)
	by vm02.inforoutes.fr (8.14.4/8.14.4) with ESMTP id s96HQe6k029889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 6 Oct 2014 19:26:40 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

We are currently working on a project which may need the use of nftables
to queue AF_BRIDGE packets to the userspace and back. Apparently this
is already supported in the nftables code itself, but not in the
bridge netfilter code (the corresponding nf_afinfo is missing, at least).

I would like to know if there are plans to support this? If yes, in what
timeframe? If no, would you be interested if we were to submit a patch
to that effect?
Also, what should be included in the payload send to userspace?
(starting from the 802.3 LLC/protocol header, or also including up to
the MAC addresses ?)

regards
stephane bryant
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUMtDSAAoJEKNzxWR1tbW0wfIP/ix2furH4/z6Kxl2lAFtCoiJ
S783U0TosC1rZG394a81Myxm+QrdGPzpJ0nLOnAaztNy7cqxxnnzBdqd1A40vaZ1
LnCI+aC5yo9qqc7FRljovMSKgaQ5UI2Hf2Tcd2RaoB1j4GVn+fd2GxbX2fls6JaC
c2U/5plUfRkAeM43ggCDFMwBpl3UhUbz8NutZ9H2vN7BnEIQvtB6ixbzNaDfqUpn
JuXW2x19UfADBlxVzNon//nWJjloWQTsO1DN2jlciwatbMQnBF+e4GNHyRB8T34Q
Dsd+HOSX/YT8Wuzi9PeXkq/k1IAxG6PDygu56WqBDM4nzZUpwvKiGIQ2Mb8pYbVv
ImTy2T6mn+aPVwSPyCVNpF3PNzWKZCFvkDJdSdbW/r6u1ZecIIzEmvdX5dWPpx3b
7+x/NlBlKAKXABBxinXsSsaHNNVTyB0lDltbcd87knG/0nWrLUwj+j9K8VRUki/t
DbK8Kt5cAhmjVUUdNo9RS6TNhvCDMF0oGdVrV2yU+cJXsffc4afmjnF0QnxNQj7c
ctIXbZTVO8UPC3Jp0DdeI6cyXTFU+1meKhZNasoQmqaWElnfQ9XqZ7SXT8+XZZlT
Jrl8t2gwB7Qb5EByiOIwKLkU4p3c+nSegi2IGRvm9rCvk119R8RuLro4fRogS5Uw
p2NdVo7EFQ6VDX8bscuH
=2H16
-----END PGP SIGNATURE-----
