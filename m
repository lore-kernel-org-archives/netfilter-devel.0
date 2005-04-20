From: Wang Jian <lark@linux.net.cn>
Subject: Re: conntrack session information
Date: Wed, 20 Apr 2005 22:18:09 +0800
Message-ID: <20050420220640.03B8.LARK@linux.net.cn>
References: <20050420213357.03AF.LARK@linux.net.cn>
	<42665E0D.2090609@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42665E0D.2090609@ufomechanic.net>
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

Hi Amin Azez,


On Wed, 20 Apr 2005 14:50:05 +0100, Amin Azez <azez@ufomechanic.net> wrote:

> Wang Jian wrote:
> > Hi Amin Azez,
> > 
> > It is most easy to use an unique id which will not wrap for quite
> > sometime, but I think the overhead (size) is too much.
> 
> 4 or 8 bytes per conntrack is small I think.

It is small. But didn't we get size per conntrack cut lately? Then we
add more bytes to it once again?

> 
> > The alternative way to do it is just adding protocol information to
> > every event message, so the tuple of conntrack is complete. The tuple
> > will not duplicate during its lifetime, am I wrong? This is enough to
> > build up the whole session. I assume that two conntracks using the same
> > tuple are always perfect serialized, in the NEW, DESTROY, NEW, DESTROY
> > order, not in NEW, NEW, DESTROY, DESTORY order.
> 
> This is so, and /probably/ combined with the contrack creation time will 
> make a historically unique id.
> 
> > If you are using a sql database to store the session, it is easy. If you
> > are not using sql database, you have to do a little more work but not
> > big deal.
> 
> It is a matter of convenience, not neccessity, and the ease with which 
> conntrack(-tool) and other clients can relate conntracks accross 
> conntrack events.

Agree. But is the pay worthy of the overhead added? I am not the one to
decide here. Best to leave that for Pablo and Harald to decide.

> 
> > The tricky issue when building session is that DESTORY message gets lost.
> > This troubles unique id way as well as tuple way.
> 
> When combined with conntrack creation time, this is not a problem either 
> way.

Even without creation time, I think it it ok now. Just consider the
unclosed [NEW] conntrack is closed when another [NEW] appears.

> 
> How do you feel about conntrack creation time being part of the 
> conntrack data?

I think it is not necessary ;)

> 
> > 
> > On Wed, 20 Apr 2005 13:11:14 +0100, Amin Azez <azez@ufomechanic.net> wrote:
> > 
> > 
> >>Wang Jian wrote:
> >>
> >>>There is problem to create whole sessions record from events. event
> >>>messages should carry necessary information for correlation
> >>
> >>I'm proposing that we base this session id on a 64 bit counter.
> >>I will also want to adjust conntrack to record the system time at which 
> >>the conntrack was created anyway.
> >>
> >>If we also associate with this a serial number, the chances "in normal 
> >>use" that the counter will wrap around with the same system time are 
> >>miniscule.
> >>
> >>For most purposes the connection serial number is unique, but the 
> >>associated timestamp makes it historically unique.
> >>
> >>Final question, I suppose that ip_conntrack.master references will cause 
> >>the master conntrack (of related conntracks) to hang around until the 
> >>related conntracks have been deleted? Thus, the netlink stuff can report 
> >>the id of the master conntrack when it reports other conntrack info.
> >>
> >>Does this sound reasonable to folk? Is this too much overheard per 
> >>conntrack? What bottlenecks are there?
> >>
> >>Maybe it would require a cross-cpu counter with serialized access. Is 
> >>there a standard kernel form for this, or do we use spinlocked structs 
> >>or something? Or is a per-cpu counter preferred, combined with a CPU-id?
> >>
> >>Amin
> >>
> > 
> > 
> > 
> > 
> 



-- 
  lark
