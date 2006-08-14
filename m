From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 17:28:19 +0200
Message-ID: <44E09693.9000606@trash.net>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814152026.GU7194@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> 2006-08-14 16:31:34+0200, Patrick McHardy <kaber@trash.net> ->
> 
>
>>>I do not completly understand you. Today a modification of ONE rule will or
>>>will not trigger the checkentry()/init() of ALL rules? 
>>
>>Yes it will. Modification happens like this:
>>
>>- dump entire table to userspace
>>- modify table
>>- send new table to kernel
>>
>>_All_ matches and target and reinstantiated, since the kernel doesn't
>>know which rule in the currently active table corresponds to which
>>in the new table. When moving state out of the data shared with
>>userspace it will get lost during this.
>>
> 
> Lost? Like the memory will be reallocated and we have a memory leak from the
> old priv_data?

No, the contents will be lost since the allocated memory belonging to
the old table will get freed and new memory is allocated for the new
table.

> Can't we just figure out if thie pointer is null and don't allocate new
> memory?
> 
> Or am i lost here?

It won't be non-NULL since we're always initializing a new table from
the kernels POV.

>>Well, if nobody can use it reasonable there is no reason to introduce
>>it.
> 
> 
> Alot of my patches can use it. Not having todo an ugly solution trying to
> sneak away from being reseted when another rule is altered. I sure would
> like to have it added. Simpyl do not change for example -m limit into using
> it if it breaks the "feature" of reseting its state then altering another
> unrelated rule.
> 
> Please have a look here for 4 modules "needing" this patch:
> http://www.gozem.se/~gozem/netfilter/

Please post your examples to the list.

> I'm copying here the code they are using today to workaround this
> reset-"feature":
> 
> struct info {
> 	... data here ...
> 	atomic_t refcount;
> };
> 
> init() {
> 	/* Already initiated? Since this is runned each time ANY rule is changed */
> 	if (lim->state != NULL) {


I'm not sure I understand what you're trying to show here,
but I assume its some kind of shared state between multiple
instances of your "lim" match. the first question would be:
where does the state pointer get its value from here?
You can't rely on userspace passing back a valid pointer,
this is questionable today (CAP_NET_ADMIN might crash the
box), but its a huge bug once you consider things like
OpenVZ.
