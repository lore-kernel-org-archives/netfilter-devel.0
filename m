From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Thu, 18 Mar 2004 02:15:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403180152360.18641-100000@filer.marasystems.com>
References: <1079567983.2115.10.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Victor Julien <victor@nk.nl>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
In-Reply-To: <1079567983.2115.10.camel@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, John A. Sullivan III wrote:

> I found that there were a few other differences.  As far as I can tell,
> you can only have one table section per file, in other words if I have a
> file such as
>
> *nat
> some rules
> COMMIT
> *filter
> some more rules
> COMMIT
> *nat
> some more rules
> COMMIT
>
> only the first set of NAT rules commits.

If this is the case then it is a bug somewhere, most likely in libiptc..

seems to work fine here however.. tested with

*filter
-A INPUT -p tcp --dport 45 -j ACCEPT
COMMIT
*nat
-A PREROUTING -p tcp --dport 45 -j ACCEPT
COMMIT
*filter
-A OUTPUT -j ACCEPT
COMMIT

and all three rules was added just fine.

also I do not see any reason why it should not work. The libiptc handle is 
completely closed on COMMIT so there should not be any memory of you 
already have used this table when the new *tablename is reached.

Note: when doing this you MUST use the --noflush (-n) option. If not the
second reference to the table will clear the rules added by the first..

> I also found that I needed to use an explicit declaration of implicit
> matches, e.g.,
>
> *filter
> -A FORWARD -p 6 --dport 80 -j ACCEPT - does not work
> -A FORWARD -p 6 -m tcp --dport 80 -j ACCEPT - does work
> COMMIT

Works fine here without.. and considering that the exact same iptables.c 
is used in both commands for parsing the commands I don't see why it 
should not work in any version of iptables-restore..

The fact that iptables-save prints the protocol match is only due to the
fact that this is actually what the rules looks like if you are protocol
match options.. there is some heavy duty "magics" in iptables command
parsing if a protocol is specified but no protocol match. There is an
interesting comment in iptables.c which summarises this magic protocol
match function quite well ;-)

                                /* If you listen carefully, you can
                                   actually hear this code suck. */


Regards
Henrik
