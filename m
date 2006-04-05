From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Update: Patch-o-matic cleanup
Date: Wed, 05 Apr 2006 17:20:21 +0200
Message-ID: <4433E035.2010504@gmx.net>
References: <443165AA.4030509@trash.net> <4433CA75.9040607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4433CA75.9040607@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Patrick McHardy schrieb:
> 
> After receiving multiple "please keep this patch" mails, it seems I
> started the wrong way.
> 
> Removing old patches is part of a greater plan to reduce the content of
> pom to only those things the netfilter team has an interest in
> maintaining, and most of these things will be merged in not too long
> time. _All_ other patches will be removed and the "runme" tool will
> be enhanced by an apt-get like mechanism to download patches from
> external sources[...]

But why keep a few patches in pom and throw out the rest? Wouldn't it
make sense to reduce pom to a simple script and throw out all patches?
The few patches maintained by the netfilter team could be moved to a
separate pom-hotfix package and be automatically downloaded by the
pom script.

OTOH, having a pom-ng that can be applied without a network connection
was very helpful for me in the past. So if you are really going to
discontinue pom-ng as is, I offer to take over maintenance. Fetching
the different packages from locations in a list and assembling them
into one pom-full package automatically can't be that difficult.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
