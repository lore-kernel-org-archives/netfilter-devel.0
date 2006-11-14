From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: 14 Nov 2006 10:24:35 +0100
Message-ID: <m3wt5yl6ss.fsf@ursa.amorsen.dk>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
	<Pine.NEB.4.64.0611121933050.20892@ukato.freeshell.org>
	<20061112194314.GA3542@linuxace.com>
	<Pine.NEB.4.64.0611130053020.6631@ukato.freeshell.org>
	<45581D66.2070009@rtij.nl>
	<Pine.NEB.4.64.0611131546380.26786@ukato.freeshell.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

>>>>> "AT" == Alexey Toptygin <alexeyt@freeshell.org> writes:

AT> No, domains can't start with a digit. See RFC 1034:

AT> ftp://ftp.rfc-editor.org/in-notes/rfc1034.txt

>> From which I quote:

>> <domain> ::= <subdomain> | " "
>> 

You forgot to quote the section heading:

>> 3.5. Preferred name syntax

You also forgot this bit:

>> The following syntax will result in fewer problems with many
>> applications that use domain names (e.g., mail, TELNET).

as well as numerous other places in that section, where it is made
very clear that the syntax is merely a recommendation.

RFC 1034 is probably the most misread RFC in existence. Please do not
contribute further to this problem.


/Benny
