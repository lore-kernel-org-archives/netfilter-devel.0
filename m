From: Evrim ULU <evrim@core.gen.tr>
Subject: Re: can tcp stream reassembly be done in netfilter
Date: Tue, 26 Aug 2003 23:38:44 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4BC554.9080902@core.gen.tr>
References: <200308261011937.SM00856@zhengcb> <Pine.LNX.4.53.0308271030240.2748@oskar-lap.agatha>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.53.0308271030240.2748@oskar-lap.agatha>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Oskar Andreasson wrote:

>On Tue, 26 Aug 2003, zhengchuanbo wrote:
>  
>
>>	Can netfilter do the tcp stream reassembly? I mean something like
>>what snort do in the stream process. I wish this could be done in the
>>kernel.
>>    
>>
>
>No, netfilter is a packet filter. It works on a per packet basis, below
>
>streams. That's when you should use snort or proxy solutions of one sort
>or another.
>
>  
>
Hi,

I am considering to try this one. Snort is a crap on behalf of my 
examinations about tcpreassambly code. (see state evasion bug) Linux 
kernel includes tcp reassembly thing and one can use it to glue data for 
signature check. The only reason for this is, *why don't we have a 
kernel based signature ids?*. Anybody interested in discussion may mail 
me, don't want to abuse ppl here.

Evrim.
