From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 16:40:41 +0200
Message-ID: <200608141640.41759.max@nucleus.it>
References: <44E07BCD.8030206@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44E07BCD.8030206@trash.net>
Content-Disposition: inline
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

On Monday 14 August 2006 3:34 pm, you wrote:

> While merging the priv_data patch I noticed an oversight. Currently,
> when modifying the ruleset, all modules dump their entire state
> (user configuration + internal state kept in the same structure)
> to userspace, which will return it to the kernel. That means for
> example that the limit match will not loose its current state when
> modifying other rules. When we move the state out of the data shared
> with userspace this can't be done anymore, so each modification to
> the table will cause all modules to loose their current state, even
> if they we're not directly affected by the change. We can't break
> this behaviour, so this limits potential users of the priv_data stuff
> to things like hashlimit or recent, which do a lookup of state stored
> completely external from the ruleset (and could use it to cache the
> lookup result). I don't think that this is worth it, we probably need
> to wait until we have a better userspace interface before we can do
> something like this ..

I'm afraid you are right. This limits the usefulness to volatile data that can 
safely be discarded. This can be some sort of disposable statistic or 
performance enhancing cache of data that can be retrieved in other ways.

Without this patch we are condemned to ugly tricks for data needed by 
condition, hashlimit and recent. I think this is useful, but I'll leave it to 
you to decide if it's worth.

Any idea for a better userspace interface?
It's not the first time you tell me that we could have a better "next 
generation" userspace interface. Maybe it's time to start planning.
Does anyone have wishes for new or different ways to do things?

Just an example without proper thought or planning: we could set an optional 
way rules could use to tag themselves and have their data back if they want 
it. As with priv_data this won't benefit everyone. I'll keep thinking of 
better ways.

IMHO a portion of data outside the one passed by userspace (persistent or 
volatile) is a must in the long run and will free us from an arbitrary 
constraint between userspace and kernelspace. I see other people are writing 
matches that rely on separate user input to complete its data (interface 
groups?) and they will need somewhere to store it.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
