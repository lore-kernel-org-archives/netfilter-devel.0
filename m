From: Patrick McHardy <kaber@trash.net>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Sun, 22 Aug 2004 02:30:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4127E920.2080100@trash.net>
References: <20040818223233.GA317@cerbere.dyndns.info> <20040819094720.GZ3921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Samir Bellabes <sam@cerbere.dyndns.info>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040819094720.GZ3921@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>On Thu, Aug 19, 2004 at 12:32:33AM +0200, Samir Bellabes wrote:
>  
>
>>Hi Harald,
>>
>>   It's seems that the file
>>   p-o-m/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h
>>   is missing.
>>    
>>
>
>Erm, it's not missing.  It is in the linux-2.4 and linux-2.6 shared 
>
>	pom/osf/linux/include/linux/netfilter_ipv4/
>
>directory in order to avoid duplication of the same file at two
>locations within cvs.
>  
>

Oops. I just commited the file to 2.6, I didn't knew this works.
How come it didn't compile ?

Regards
Patrick
