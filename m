From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 5/7] make netfilter use strict integer types
Date: Wed, 25 Feb 2009 16:24:38 -0800
Message-ID: <49A5E146.4060208@zytor.com>
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
> On Thursday 2009-02-26 00:51, arnd@arndb.de wrote:
> 
>> Netfilter traditionally uses BSD integer types in its
>> interface headers. This changes it to use the Linux
>> strict integer types, like everyone else.
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
>> -	u_int8_t flags;
>> -	u_int8_t mask;
>> +	__u8 flags;
>> +	__u8 mask;

Not to mention the fact that the standard type is uint8_t, not u_int8_t 
as the file currently have, which makes it double broken.
	
	-hpa
