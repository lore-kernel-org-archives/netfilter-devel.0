From: =?UTF-8?B?UGVra2EgUGlldGlrw6RpbmVu?= <pp@ee.oulu.fi>
Subject: Re: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes behavioural
 change in userspace?
Date: Thu, 24 Oct 2013 15:27:06 +0300
Message-ID: <5269121A.3040104@ee.oulu.fi>
References: <52667EBC.5010709@ee.oulu.fi> <20131024095212.GA4422@localhost>	 <1382609706.7572.48.camel@edumazet-glaptop.roam.corp.google.com>	 <526902D1.50803@ee.oulu.fi> <1382616307.7572.56.camel@edumazet-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020704010102040607040300"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, edumazet@google.com,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ee.oulu.fi ([130.231.61.23]:55481 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3JXM1L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:27:11 -0400
In-Reply-To: <1382616307.7572.56.camel@edumazet-glaptop.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020704010102040607040300
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/10/13 15:05, Eric Dumazet wrote:
> sk_state 7 means TCP_CLOSE
>
> I do not see how a TCP_CLOSE socket can be matched...
>
Yep, TCP_CLOSE can't be right, sk_state isn't correct with early demux 
perhaps?

Finding 
https://android.googlesource.com/kernel/common/+/experimental/android-3.8%5E!/ 
I managed to get  the old behaviour with the attached patch, but I'm 
having a hard time following what's really happening.




--------------020704010102040607040300
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="xt_socket.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xt_socket.diff"

LS0tIC91c3Ivc3JjL2RlYnVnL2tlcm5lbC0zLjExLmZjMTkvbGludXgtMy4xMS42LTIwMC5m
YzE5Lng4Nl82NC9uZXQvbmV0ZmlsdGVyL3h0X3NvY2tldC5jCTIwMTMtMDktMDIgMjM6NDY6
MTAuMDAwMDAwMDAwICswMzAwCisrKyB4dF9zb2NrZXQuYwkyMDEzLTEwLTI0IDE1OjA3OjU5
LjU5MjYwNzQzMyArMDMwMApAQCAtMTE1LDYgKzExNSw4IEBACiAJc3RydWN0IG5mX2Nvbm4g
Y29uc3QgKmN0OwogCWVudW0gaXBfY29ubnRyYWNrX2luZm8gY3RpbmZvOwogI2VuZGlmCisJ
aWYgKHNrICYmIHNrLT5za19zdGF0ZSA9PSBUQ1BfQ0xPU0UpCisJICBzayA9IE5VTEw7CiAK
IAlpZiAoaXBoLT5wcm90b2NvbCA9PSBJUFBST1RPX1VEUCB8fCBpcGgtPnByb3RvY29sID09
IElQUFJPVE9fVENQKSB7CiAJCWhwID0gc2tiX2hlYWRlcl9wb2ludGVyKHNrYiwgaXBfaGRy
bGVuKHNrYiksCg==
--------------020704010102040607040300--
