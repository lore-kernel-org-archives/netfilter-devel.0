From: Johan Ankarloo <johan.ankarloo@volvo.com>
Subject: Re: DNAT/SNAT and logging
Date: Wed, 21 Jan 2004 10:33:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074677621.14990.11.camel@ankarloo.got.volvo.net>
References: <Pine.LNX.4.44.0401211018500.4023-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0401211018500.4023-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I'm not shure i agree. The problem here is that the logging is done
seperate from the modules that mangle the packets. The right way ( for
me ) would be to have the mangle modules send the logging information to
the logging module. In this way the mangle modules could say what has
been altered in the packet. 

This information has to be included so that it is possible to trace the
packet back. Think of a large company that do a lot of nat for big
networks. How is it possible for the IT-staff to see what have happend?
In other brands ( read checkpoint, cisco .... ) they include this
information.

Regards

Johan

On Wed, 2004-01-21 at 10:21, Henrik Nordstrom wrote:
> On Tue, 20 Jan 2004, Johan Ankarloo wrote:
> 
> > is above the actually mangle line, the log target won't know how the
> > packet will be mangle. What i need in the log files are something like:
> > 
> > Original Source 
> > Original SourcePort 
> > Original Destination 
> > Original DestinationPort
> > Translated Source 
> > Translated SourcePort 
> > Translated Destination 
> > Translated DestinationPort
> 
> Then you need another LOG type target which logs the conntrack information 
> rather than the packet information, and on NEW packets you need to have 
> this logged after the SNAT rule have been applied.
> 
> Maybe ctnetlink can help.
> 
> Regards
> Henrik
