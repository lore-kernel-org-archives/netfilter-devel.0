From: Herve Eychenne <rv@wallfire.org>
Subject: Re: RAM and conntrack performance: first draft of the document is online
Date: Thu, 27 Nov 2003 05:56:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031127045620.GA2740@eychenne.org>
References: <20031126034231.GA1044@eychenne.org> <Pine.LNX.4.44.0311260512440.6942-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>,
	"Laurence J. Lane" <ljlane@debian.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311260512440.6942-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Nov 26, 2003 at 05:13:49AM +0100, Henrik Nordstrom wrote:

> On Wed, 26 Nov 2003, Herve Eychenne wrote:

> > Debian standard kernel.  Maybe they are patching netfilter?  These are smart
> > guys! ;-)

> Or maybe you/they have a prime set in modules.conf?

I looked at both modules.conf and Debian kernel source (patched, but
netfilter code seems unaffected), and could find nothing that explains
why I have 4091 buckets (which is indeed a prime number, that's cool)
by default instead of 4096 (I have 512MB).

So it's a bit strange.


Debian iptables package maintainer TO'ed.

Context: I have a Debian testing (sarge) with kernel-image-2.4.22-1-686
package and 512MB of RAM.  I should then logically get ip_conntrack
module initialized with 4096 buckets (size of the netfilter conntrack hash
table, that should be computed automatically by netfilter code according
to the amount of RAM), but I can read 4091 in syslog message.
4091 is better (prime number), but I cannot understand why I get this value
instead of 4096, as nothing particular is done for the moment in
netfilter code to ensure that the computed value will be a prime number.

For further reading about the subject, you can read
http://www.wallfire.org/misc/netfilter_conntrack_perf.txt

Any ideas, Laurence?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
