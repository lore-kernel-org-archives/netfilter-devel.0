From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC]: ip_conntrack breaks UDP PMTU
Date: Sat, 15 Feb 2003 06:12:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E4DCC41.1040604@trash.net>
References: <20030214080612.GN14794@sunbeam.de.gnumonks.org> <3E4CF238.2030207@trash.net> <20030214145521.GB17921@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   coreteam@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030214145521.GB17921@sunbeam.de.gnumonks.org>
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

>On Fri, Feb 14, 2003 at 02:42:16PM +0100, Patrick McHardy wrote:
>
>  
>
>>Usually all fragments except the last one will have equal size, so the
>>fragment sizes can be stored as (size, boundary) tuples. I would
>>suggest making the max.
>>    
>>
>
>yes, usually.  But if we implement this 'fragment-backlog', we should do
>it as good as possible.  
>
>I see people already whining about 'firewall can be detected because
>overlapping fragments are not present after passing through' or stuff
>like this :((
>

This is probably unavoidable as long as we want to use ip_defrag. I think we
really don't want the "perfect solution".

>
>  
>
>>number of different fragment sizes fixed or controllable via sysctl and 
>>set it to some low default (like 4). This would reduce the amount of
>>memory per reassembled packet to 4 * (2b + 2b) = 16b.
>>    
>>
>
>so what do we do if the number is exceeded?  fallback to current
>behaviour?
>

I have to admit, i really don't know,  I would favour dropping such
crap with a higher default of maybe 8-16, although i understand
conntrack should not drop any packets.

I guess some cruel decisions have to be made here, and we haven't even
started to think about mangling nat helpers ..

Bye,
Patrick
