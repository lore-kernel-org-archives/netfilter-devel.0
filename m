From: Max Kellermann <max@duempel.org>
Subject: Re: Cannot apply h323-conntrack-nat
Date: Fri, 25 Mar 2005 23:20:27 +0100
Message-ID: <20050325222027.GA12915@roonstrasse.net>
References: <1111695753.32351.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Javier Kohen <jkohen@users.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1111695753.32351.34.camel@localhost>
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

On 2005/03/24 21:22, Javier Kohen <jkohen@users.sourceforge.net> wrote:
> I'm trying to apply the h323-conntrack-nat patch to kernel 2.6.11-ck2
> using pom-ng revision 3805, but it keeps saying: «unable to find ladd
> slot in src /tmp/pom-29949/include/linux/netfilter_ipv4/ip_conntrack.h.»
> Note that the -ck2 patchset does not modify file ip_conntrack.h.

Hi Javier,

I have already posted patches to h323-conntrack-nat, unfortunately
they have not been applied to svn yet. You can find patches against
pom-ng trunk on my home page:

 http://max.kellermann.name/projects/netfilter/h323.html

Max
