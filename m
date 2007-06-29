From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 20/20]: nf_conntrack_h323: turn some printks into
 DEBUGPs
Date: Fri, 29 Jun 2007 12:08:25 +0200
Message-ID: <4684DA19.9020802@trash.net>
References: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
	<20070629004422.25566.75551.sendpatchset@localhost.localdomain>
	<Pine.LNX.4.64.0706290942550.22579@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706290942550.22579@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> Hi,
>
> On Jun 29 2007 02:45, Patrick McHardy wrote:
>   
>> [NETFILTER]: nf_conntrack_h323: turn some printks into DEBUGPs
>>     
>
> Should it be pr_debug?
>
>   

It should, but the file currently uses DEBUGP.
