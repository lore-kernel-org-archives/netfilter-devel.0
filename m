From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [FUN] new netfilter matching module : passive OS fingerprint
Date: Thu, 11 Sep 2003 13:12:39 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0309111308560.17138@dns.toxicfilms.tv>
References: <20030908161734.7c0f7420.johnpol@2ka.mipt.ru>
 <Pine.LNX.4.51.0309101651030.9903@dns.toxicfilms.tv>
 <20030910200113.3113dd1c.johnpol@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20030910200113.3113dd1c.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I have an idea to make fingerprint table dynamic and write a little
> program to parse and load whole Michal's table through  ioctl or
> /proc.
That would be great, then fingerprints could be easily added without
recompilating the modules.

osf could also be made a target, that would work like LOG, and would
log basically things that are with OSF_DEBUG, but maybe showed the IP
too.
You could then do simple OS accounting and see if there's more linux or
any other traffic.

> 	Evgeniy Polyakov ( s0mbre )
Maciej
