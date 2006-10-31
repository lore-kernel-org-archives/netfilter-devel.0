From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] new API for libnetfilter_conntrack
Date: Tue, 31 Oct 2006 19:57:02 +0100
Message-ID: <45479C7E.5020300@netfilter.org>
References: <45456285.4010609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

JFYI: I'm going to finish the patch and then get back to the list for
discussion, perhaps I was too fast to request feedback. If someone is
interested in the evolution of the proposed new API, I'll be updating
the patch on my people netfilter place.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
