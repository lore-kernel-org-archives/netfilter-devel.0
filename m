From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ip_nat_snmp_basic issue!
Date: Wed, 06 Apr 2005 09:36:51 +1000
Message-ID: <1112744211.24374.5.camel@localhost.localdomain>
References: <WorldClient-F200504051323.AA23210105@basirat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	jamesm@redhat.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mohsen Basirat <mohsen@basirat.com>
In-Reply-To: <WorldClient-F200504051323.AA23210105@basirat.com>
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

On Tue, 2005-04-05 at 13:23 -0500, Mohsen Basirat wrote:
> Dear Rusty,
> 
> I was trying to use ip_nat_snmp_basic but unfortantly it does not work. I
> just googled and found out that you have been following the issues w/ this
> module and added some code for the 2.6.11-rc2.
> So would u mind let me know how I can make this module work! 
> I just modprobe the module and define one SNAT,DNAT but nothing hapens!
> It does not change the ip addresses in the payload !
> I am using kernel 2.6.11.6 and iptables 1.2.11.
> 
> here is the iptables nat rules:
> iptables -t nat -A PREROUTING -d 192.168.201.185 -i eth0 -j DNAT
> --to-destination 10.21.1.4
> iptables -t nat -A POSTROUTING -s 10.21.1.4 -o eth0 -j SNAT --to-source
> 192.168.201.185
> 
> Rusty, I will be so thankful if u help me figure it out.

It was converted to the new netfilter stuff, but without a testcase in
nfsim, I don't know if it actually works.  I keep hoping someone will
write the testcase and we'll be able to see what I broke...

James, you bored with that crypto crap yet?
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
