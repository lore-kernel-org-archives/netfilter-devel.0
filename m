From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 5/7] make netfilter use strict integer types
Date: Wed, 25 Feb 2009 17:02:22 -0800
Message-ID: <49A5EA1E.5@zytor.com>
References: <20090225235138.062045835@arndb.de> <20090225235515.682333715@arndb.de> <alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr> <49A5DECD.7090809@zytor.com> <alpine.LSU.2.00.0902260137001.23768@fbirervta.pbzchgretzou.qr>
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
In-Reply-To: <alpine.LSU.2.00.0902260137001.23768@fbirervta.pbzchgretzou.qr>
Sender: linux-arch-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Thursday 2009-02-26 01:14, H. Peter Anvin wrote:
>>> [...]
>>> IMHO, __uXX should be replaced by uintX_t, but a move this great I
>>> will leave to future generations because there is just too much
>>> persisting opinions wrt. such proposal. As such I'd like to join
>>> and persist on my position and that uintX that we have should be kept.
>> We *CAN'T* replace __uXX with uintX_t.  Period, full stop, end of story.
> 
> Would the mindful master please elaborate why this is so, if it is
> indeed not a personal decision.

POSIX has strict rules as to what symbols you are allowed to present 
into the user-visible namespace.  This means you can't use these types 
for any header that may be indirectly included.

Since we can't use them in general, it's silly to use them for a 
minority of headers, which would then have different exposure rules than 
people otherwise can expect.

	-hpa
