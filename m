From: Ben La Monica <ben.lamonica@gmail.com>
Subject: Re: ULOG and bandwidth monitor
Date: Mon, 14 Feb 2005 17:13:12 -0700
Message-ID: <7174b1e405021416134d63fd4e@mail.gmail.com>
References: <421134A9.8010204@utilitran.com>
Reply-To: Ben La Monica <ben.lamonica@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Michael Gale <michael.gale@utilitran.com>
In-Reply-To: <421134A9.8010204@utilitran.com>
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

Hello,

On Mon, 14 Feb 2005 16:30:49 -0700, Michael Gale
<michael.gale@utilitran.com> wrote:
> Hello,
> 
>         I have recently downloaded ulogd-1.02 and gone through the
> documentation. With the mysql plugin, it would seem very easy to create
> a web base front end to produce total stats.

ulog has problems when there is a lot of traffic flowing, and it drops
packets. This is because that it passes every packet into userspace
and it usually runs out of buffer space. I think there are plans to
actually integrate a conntrack-acct module into ulogd (I can't find
the post right now, so I can't provide a reference).

> I am curious as to why no developers have done so ? I am trying to move
> into development, as a hubbyist (for now) so I could be way off base.

I'm actually working on a project that will provide what you're
looking for. It's basically an internet gateway that has a nice web
interface. It was nearly done until I decided to clean it up and
prepare it for an open source release. It does things like monitoring
bandwidth per user, analyze traffic and provide access control. It
creates very pretty bandwidth graphs :)

It's written mainly in PHP. If you're interested in helping out e-mail
me and I can give you read access to the CVS repository.

Or, if you would just like to work on something that will provide
accounting information, you can look into conntrack-acct and
integrating it into ulogd.

-Ben La Monica
