From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 16:48:27 +0200
Message-ID: <44E08D3B.7040505@trash.net>
References: <44E07BCD.8030206@trash.net> <200608141640.41759.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200608141640.41759.max@nucleus.it>
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

Massimiliano Hofer wrote:
> On Monday 14 August 2006 3:34 pm, you wrote:
> 
>>[...]
>
> I'm afraid you are right. This limits the usefulness to volatile data that can 
> safely be discarded. This can be some sort of disposable statistic or 
> performance enhancing cache of data that can be retrieved in other ways.

Agreed.

> Without this patch we are condemned to ugly tricks for data needed by 
> condition, hashlimit and recent. I think this is useful, but I'll leave it to 
> you to decide if it's worth.

Hmm .. recent does a table lookup during runtime and the table could be
cached. That would improve things a bit, but in my opinion not enough
to justify this patch. Same for hashlimit. What data would condition
store exactly?

> Any idea for a better userspace interface?
> It's not the first time you tell me that we could have a better "next 
> generation" userspace interface. Maybe it's time to start planning.
> Does anyone have wishes for new or different ways to do things?


Its actually quite clear what is needed. We want a userspace interface
built on netlink, that acts on individual rules, not entire rulesets.
There are a few more ideas, like handling negation centrally, allowing
userspace to specify whether a target is terminal or not, allow multiple
non-terminal targets in a row, etc, but nothing really fundamental.

> Just an example without proper thought or planning: we could set an optional 
> way rules could use to tag themselves and have their data back if they want 
> it. As with priv_data this won't benefit everyone. I'll keep thinking of 
> better ways.


We want to get rid of the atomic table replacements entirely.

> IMHO a portion of data outside the one passed by userspace (persistent or 
> volatile) is a must in the long run and will free us from an arbitrary 
> constraint between userspace and kernelspace. I see other people are writing 
> matches that rely on separate user input to complete its data (interface 
> groups?) and they will need somewhere to store it.


Once we stop replacing entire rulesets and move to a finer grained level
this problem will be gone, state will be kept for all rules except the
ones affected. Using netlink attributes will also allow us to flexibly
enhance the interface as needed.
