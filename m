From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 5/7] make netfilter use strict integer types
Date: Wed, 25 Feb 2009 16:14:05 -0800
Message-ID: <49A5DECD.7090809@zytor.com>
References: <20090225235138.062045835@arndb.de> <20090225235515.682333715@arndb.de> <alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: arnd@arndb.de, Sam Ravnborg <sam@ravnborg.org>,
	Kyle McMartin <kyle@infradead.org>,
	Ingo Molnar <mingo@elte.hu>,
	Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
	mingo@redhat.com, dwmw2@infradead.org,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr>
Sender: linux-arch-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> 
> I _strongly disagree_ with this move. Userspace also has the uintX
> types via <stdint.h>/<cstdint>, and now you are adding a dependency
> on linux/types.h, not to mention that your step can lead to compile
> time piling up.
> 
> IMHO, __uXX should be replaced by uintX_t, but a move this great I
> will leave to future generations because there is just too much
> persisting opinions wrt. such proposal. As such I'd like to join
> and persist on my position and that uintX that we have should be kept.
> 

We *CAN'T* replace __uXX with uintX_t.  Period, full stop, end of story. 
  It isn't possible to do universally, and doing it non-universally is 
just silly.  Nor is it likely that this adds anything to the compile 
time, since most realistic programs will have a dependency on 
<linux/types.h> through some indirect path.

Now, I have to say I'd personally would prefer if make headers_install 
did this transformation mechanically for the common integer types, 
instead of requiring it to have the source code formatted in a specific 
fashion.

	-hpa
