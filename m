From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ULOG / netlink errors
Date: Thu, 16 Dec 2004 15:42:07 +0000
Message-ID: <41C1ACCF.6040604@eurodev.net>
References: <20041128113728.GA17226@oasis.frogfoot.net>
	<41AA3723.9070708@eurodev.net> <41AA39FC.1000400@eurodev.net>
	<20041216134127.GI10165@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>,
	Abraham van der Merwe <abz@frogfoot.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041216134127.GI10165@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:

>On Sun, Nov 28, 2004 at 09:50:04PM +0100, Pablo Neira wrote:
>  
>
>>Pablo Neira wrote:
>>
>>    
>>
>>>this is ok, it's always a good idea to reduce the probability of an 
>>>overflow. But I think that you'll have problems anyway with traffers 
>>>rates bigger than ~20 Mbits/s.
>>>      
>>>
>>well, this is true in ip_queue, don't know in ipt_ULOG, it depends on 
>>three/four parameters.
>>    
>>
>
>just to let you know: there are people doing ULOG based acounting on >=
>100MBit.  So it's not as bad as you think it is ;)
>

I love netlink sockets, but loving someone/something implies knowing 
their limitations as well :)

I think that it depends on the settings, let me see what happen with an 
insane iptables rule like: iptables -I INPUT -j ULOG

>[no, I'm not advertising the use of ulog for accounting.  That's not
>what it was menat for].
>

I do also use ULOG(tm) to log packets, Since I do my hamster pet looks 
happier ;)

--
Pablo
