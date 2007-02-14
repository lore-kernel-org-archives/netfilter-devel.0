From: Sebastien Tricaud <sebastien.tricaud@wengo.com>
Subject: Re: Change Packet Payload
Date: Wed, 14 Feb 2007 11:05:14 +0100
Message-ID: <45D2DEDA.7020204@wengo.com>
References: <1171012218.4162.27.camel@LinuxCampo>	<1171013512.18531.5.camel@localhost>	<45D23748.2090609@netfilter.org>	<45D2DA9E.4010005@wengo.com>
	<45D2DBFB.7040702@trash.net> <45D2DCA9.1050100@wengo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Sebastien Tricaud <sebastien.tricaud@wengo.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D2DCA9.1050100@wengo.com>
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

This code is in several public domain or GPL tools.
For example nessus uses it :
http://cvsweb.nessus.org/cgi-bin/viewcvs.cgi/nessus-libraries/libnessus/network.c?rev=1.28

It is not a proof yet but I'm pretty confident. I have the book at home
and I will look at it tonight (Appendix F : Source code availability).



Sebastien Tricaud wrote:
> Patrick McHardy wrote:
>   
>>> +/* (c) Richard W. Stevens */
>>> +unsigned short nfq_compute_cksum(unsigned short *data, int len)
>>>     
>>>       
>> Do you have permission to put this under the GPL?
>>
>>
>>   
>>     
>
> Good point.
> As far as I know, this is public domain. However I will make sure of it
> and be back with an answer.
>
>
>
>   
