From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Mon, 03 Sep 2007 13:13:08 +0200
Message-ID: <46DBEC44.3050900@trash.net>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
	<46DBD8CD.9060804@trash.net>
	<20070903100148.GG18480@postel.suug.ch>
	<46DBDCBB.8080903@trash.net>
	<20070903101504.GI18480@postel.suug.ch>
	<46DBE7AD.3020208@trash.net>
	<20070903110335.GK18480@postel.suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070903110335.GK18480@postel.suug.ch>
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

Thomas Graf wrote:
> * Patrick McHardy <kaber@trash.net> 2007-09-03 12:53
> 
>>That looks pretty much like a list of attributes, but
>>using different attribute types. Just out of interest:
>>do you have a pointer to code doing this?
> 
> 
> Yes, see tcf_action_dump().


Right, I remeber, the entire "action order" thing. Thats a
horrible hack IMO, probably best to convert it to real lists
if possible.

> OTOH, netlabel is making heavy use of attribute lists but
> the type is constant to allow for automatic policy validation.
> I think this is the proper way of generating lists.


Fully agreed, thats also what I did in the 8021q netlink
interface.
