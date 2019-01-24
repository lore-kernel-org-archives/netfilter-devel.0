From: Steffen Nurpmeso <steffen@sdaoden.eu>
Subject: Re: 4.19.{12,[13],14}: RIP:
 0010:nf_conncount_cache_free+0x26/0x2f [nf_conncount]
Date: Fri, 25 Jan 2019 00:14:10 +0100
Message-ID: <20190124231410.YGNS4%steffen@sdaoden.eu>
References: <20190112000517.nQ-CW%steffen@sdaoden.eu>
 <20190118131055.RtuE5%steffen@sdaoden.eu>
To: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190118131055.RtuE5%steffen@sdaoden.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello and good evening,

Steffen Nurpmeso wrote in <20190118131055.RtuE5%steffen@sdaoden.eu>:
  ...
 |The problem still persists with v14.19.15, i have reverter to
 ...
 |Jan 18 12:40:00 kernel: [37953.963613] BUG: unable to handle kernel \
 |NULL pointer dereference at 0000000000000000
 ...
 |  Jan 18 00:40:00 kernel: [38154.458219] RIP: 0010:nf_conncount_cache_free\
 |  +0x26/0x2f [nf_conncount]
 ...

No problems now with v4.19.17, thank you very much!
I guess this makes an australian eight cylindre, or a 1000 KW
electric car.  Rammed straight in space here on my side, anyway.

Ciao, and keep on rocking!!!

--steffen
|
|Der Kragenbaer,                The moon bear,
|der holt sich munter           he cheerfully and one by one
|einen nach dem anderen runter  wa.ks himself off
|(By Robert Gernhardt)
