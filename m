From: "Mitesh P Choksi" <murli@icafe.co.tz>
Subject: Using SNAT to handle IP Pools
Date: Fri, 27 Sep 2002 00:15:58 +0300 (EAT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <54761.64.86.49.17.1033074958.squirrel@www.icafe.co.tz>
Reply-To: murli@icafe.co.tz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear All,

I have a set of  dial in users whom I have givne 192.168.130.0/255.255.255.0
and would like to allocate them from an ip address range 16 ip addresses of
x.x.x.96/255.255.255.240

Is this possible using SNAT, I could not find a documentation that will
exactly let me know this from the site.

I need to know what will happen when iptables runs out of IP addresses? what
will happen for incoming connections to the IP x.x.x.99, will it be
forwarded back to the "that time" SNAT of for eg. 192.168.130.43.

The nearest I reached to my requirements was on a web site that had LEASE as
a target command.

Let me know what do you people thing about it?


Regards,

Cyberdude Murli
The Earth
