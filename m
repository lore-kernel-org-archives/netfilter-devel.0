From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] new API for libnetfilter_conntrack
Date: Fri, 03 Nov 2006 11:03:03 +0100
Message-ID: <454B13D7.4070006@trash.net>
References: <45456285.4010609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <45456285.4010609@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Hi,
> 
> Attached a patch, yet incomplete, that introduces the new API for
> libnetfilter_conntrack. Basically the idea consists of providing
> "conntrack" objects constructor/destructor functions and an interface to
> get and set object attributes. The conntrack object structure is
> encapsulated therefore we can add new attributes without breaking binary
> backward compatibility. There is an example of the new API use in the
> patch (see test.c file)
> 
> See that conntrack object attributes are different from the netlink
> attributes therefore they provide a high level interface that abstract
> from netlink details. The idea is to let the programmer make the choice
> to work with high level (objects) or low level (netlink) and provide the
> gateways to switch from high to low level and vice-versa by means of
> functions to build/parse netlink messages from/to conntrack objects.
> 
> The reason why I posted this patch is because I'm thinking about
> generalizing this a bit more and provide a complete high level API that
> would be the same for all the netfilter subsystems. This will result in
> a single library to rules them all with a subdirectory that contains the
> details of every specific subsystem.
> 
> nfh = nf_open();                   /* encapsulate nfnl_open() */
> ssh = nf_setup_subsys(nfnlh, CONNTRACK); /* encapsulate
> nfnl_subsys_open() */
> ...
> ct = nf_new_object(NF_CONNTRACK_OBJECT);
> nf_set_attr_u8(ct, ATTR_XXX, value);
> nf_set_attr_u16(ct, ATTR_XXX, value);
> ...
> nf_query_object(ssh, NF_CT_CREATE, ct);
> nf_free_object(ct);
> nf_close(nfh);
> 
> I'd like to hear from you before going ahead, always appreciate your
> feedback guys. Comments welcome.


I like that approach. Its getting pretty close to the libnl API,
have you considered integrating this in libnl?
