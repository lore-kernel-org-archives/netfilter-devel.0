From: Gerry <gsker@tcfreenet.org>
Subject: Re: bug in iptables-save/iptables-restore
Date: Mon, 9 Dec 2002 20:49:50 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212092044320.3758-100000@hamster.attbi.com>
References: <20021209162858.GL2223@sunbeam.de.gnumonks.org>
Reply-To: gsker@tcfreenet.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021209162858.GL2223@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald,
I grabbed the source from cvs, compiled it -- even though I didn't have 
matching kernel and source :-) and installed it in /usr/local and ran it.


#/home2/gsker/src/iptables/netfilter/userspace>/usr/local/sbin/iptables-save | 
grep length
-A CUST_LOG -p tcp -m length --length ! 40:68 -j LOG --log-prefix 
"PACKET_LENGTH_BAD: " --log-level debug --log-tcp-options --log-ip-options 
-A CUST_LOG -p tcp -m length --length ! 40:68 -j DROP 
#/home2/gsker/src/iptables/netfilter/userspace>
#/home2/gsker/src/iptables/netfilter/userspace>/usr/local/sbin/iptables-save > 
save.out
#/home2/gsker/src/iptables/netfilter/userspace>/usr/local/sbin/iptables-restore 
./save.out

The length problem appears to be fixed! 
Thank you very much!
(it seems really slow, though.....)

Mind you I've just been installing these things from the rpms and will
probably continue to do that. I don't change my firewall very frequently and
manually editing it or sending it through sed is fine just to keep the package 
world fairly clean.

HTH,
Gerry

On Mon, 9 Dec 2002, Harald Welte wrote:

> On Sun, Nov 17, 2002 at 09:23:27AM -0600, Gerry Skerbitz wrote:
> > here are the offending lines created by iptables-save:
> > #~>iptables-save | grep length
> > -A CUST_LOG -p tcp -m length --length !40:68 -j LOG --log-prefix 
> > "PACKET_LENGTH_BAD: " --log-level 7 --log-tcp-options --log-ip-options
> > -A CUST_LOG -p tcp -m length --length !40:68 -j DROP
> > #~>
> > 
> > I just did some digging and figured out that the exclamation point 
> > should go before the --length 40:68.  I guess that's
> > what iptables-save should really do and clearly it's what narc does when 
> > it sets up the rule.
> 
> there was a bugfix for libipt_length.c, which is in latest CVS.  Could
> you try using the latest CVS version (or the latest iptables-snapshot
> from ftp.netfilter.org) and see if the bug is gone?
> 
> Thanks.
> 
> > Gerry
> 
> 

-- 
Gerry Skerbitz
gsker@tcfreenet.org
