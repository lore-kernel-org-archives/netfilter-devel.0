From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_local_deliver related query
Date: Tue, 07 Feb 2006 15:47:02 +0100
Message-ID: <43E8B2E6.9020004@trash.net>
References: <60828.10.107.26.27.1138947199.squirrel@gpo.iitb.ac.in>
	<43E36101.8020708@trash.net>
	<4503.10.12.25.5.1139034091.squirrel@gpo.iitb.ac.in>
	<37547.10.107.26.27.1139293685.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>
In-Reply-To: <37547.10.107.26.27.1139293685.squirrel@gpo.iitb.ac.in>
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

Vasantha Kumar Puttappa wrote:
> Hi Patrick,
>   Thanks for your response. I have one more thing to clarify.
>   ( Sorry in the previous I made a great mistake, I wanted to change
>   destination IP address of the packet and not the source IP address).
> 
>   ( I am referring to first figure in the following link
>  http://www.linuxsecurity.com/resource_files/firewalls/IPTables-Tutorial/iptables-tutorial.html)
> 
>   If I am not wrong, NAT is being in done in PREROUTING AND POST-ROUTING
>  stage. But what I want to do is to take packets in FILTER INPUT stage and
>  change the destination IP address ( I don't want to create any SNAT
>  corresponding to that) and give it to local process.
>  (Assume that a socket waiting with that new destination address)

NAT is also done in LOCAL_OUT (DNAT) and LOCAL_IN (SNAT).

>   So, will there be any problem ?

No, it will work fine. Again: the socket lookups are done after the
netfilter hooks were called, so they will use the changed IP address.
