From: Romain Francoise <romain@orebokech.com>
Subject: Re: [PATCH] netfilter: xt_LOG: avoid using old-style "<.>" printk prefix
Date: Wed, 12 Sep 2012 15:29:39 +0200
Message-ID: <87392n8j3w.fsf@silenus.orebokech.com>
References: <874nn5dbx9.fsf@silenus.orebokech.com>
	<20120912124826.GA12726@1984>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>, eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20120912124826.GA12726@1984> (Pablo Neira Ayuso's message of
	"Wed, 12 Sep 2012 14:48:26 +0200")
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> ebt_log chunk is missing.

Sorry, didn't notice that it has the same bug. Do you want that in the
same patch, or separate?

>>  	m->buf[m->count] = 0;
>> -	printk("%s\n", m->buf);
>> +	printk_emit(0, level, NULL, 0, "%s\n", m->buf);

> I think it should be printk_emit(-1, ... Note facility is -1.

> Thus, we skip the syslog prefix stripping (we can skip it and save
> some cycles).

I don't think that's possible, the facility is copied down to user-space
consumers and it has to be zero for the message to be identified as
originating from the kernel (0 is LOG_KERN).

As it boils down to a single test for KERN_SOH_ASCII I don't think it
matters very much.

Thanks!
