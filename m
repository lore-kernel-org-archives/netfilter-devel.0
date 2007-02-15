From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Change Packet Payload
Date: Thu, 15 Feb 2007 01:36:16 +0100
Message-ID: <45D3AB00.7080505@netfilter.org>
References: <1171012218.4162.27.camel@LinuxCampo>	<1171013512.18531.5.camel@localhost>	<45D23748.2090609@netfilter.org>	<45D2DA9E.4010005@wengo.com>	<45D2DBFB.7040702@trash.net>	<45D2DCA9.1050100@wengo.com>
	<45D2DEDA.7020204@wengo.com> <45D2DFE8.8080301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sebastien Tricaud <sebastien.tricaud@wengo.com>,
	netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D2DFE8.8080301@trash.net>
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

Patrick McHardy wrote:
> Sebastien Tricaud wrote:
>> This code is in several public domain or GPL tools.
>> For example nessus uses it :
>> http://cvsweb.nessus.org/cgi-bin/viewcvs.cgi/nessus-libraries/libnessus/network.c?rev=1.28
> 
> Yes, I found some other users of this as well, but as you say,
> that doesn't necessarily mean its OK to use.

The code seems very similar to the one that is available in RFC1071. I
recently added initial support for message checksumming to conntrackd
and used that code (slightely modified) indicating the source, thus not
explicitely licensing that part as GPL since I don't own the copyright
of it. Can we consider examples available in a RFC as public domain code?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
