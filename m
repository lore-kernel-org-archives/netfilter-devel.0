From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [FUN] new netfilter matching module : passive OS fingerprint
Date: Wed, 10 Sep 2003 20:01:13 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030910200113.3113dd1c.johnpol@2ka.mipt.ru>
References: <20030908161734.7c0f7420.johnpol@2ka.mipt.ru>
	<Pine.LNX.4.51.0309101651030.9903@dns.toxicfilms.tv>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <Pine.LNX.4.51.0309101651030.9903@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Sep 2003 17:00:25 +0200 (CEST)
Maciej Soltysiak <solt@dns.toxicfilms.tv> wrote:

> Hello Evgeniy, folks,

Good day.

> > So, if you are interested in, please see and comment :)
> I took the privilege and made a patch for netfilter CVS to include
> this module in patch-o-matic, so it would be easier for people to test
> this module as a simple patch.
> 
> I also wrote an example, added lists of available genres and wrote
> osf.patch.configure.help and osf.patch.help messages.
> 
> I am sending the patch attached for the netfilter CVS.
> 
> Also this patch is available at
> http://soltysiak.com/linux/osf.patch

Super!

I have an idea to make fingerprint table dynamic and write a little
program to parse and load whole Michal's table through  ioctl or
/proc.

> Maciej Soltysiak

	Evgeniy Polyakov ( s0mbre )
