From: "koba@koba.com.ar" <koba@koba.com.ar>
Subject: Re: About connbytes
Date: Thu, 18 Nov 2004 19:14:11 -0300
Message-ID: <419D1EB3.8030806@koba.com.ar>
References: <419052E5.4080609@koba.com.ar>	
	<20041109090422.GQ22257@sunbeam.de.gnumonks.org>
	<f663f63604111813174cc28048@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mike Carlton <mikecarlton@gmail.com>
In-Reply-To: <f663f63604111813174cc28048@mail.gmail.com>
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

Looks like there is a difference in the development stage between the 
lastest iptables connbytes and the kernel connbytes (different struct 
expected in ipt_connbytes.h). It was not useable, at least the last time 
I checked (9/2004).

The solution I found was to patch the kernel with the connbytes patch 
from pom patch-o-matic-ng-20040621 and use the lastest iptables.

Be warned, that version uses 32-bit counters (4gb per conntrack entry 
limit) but I shouldn't be a problem in most cases. Anyway, it shouldn't 
be so difficult to change them to 64-bit.

If you need I can send you a patch for 2.6.7 kernel so you can skip the 
pom part. You don't need to patch iptables, connbytes is already 
included but you'll need to recompile iptables against you patched 
kernel so the connbytes extension is included in the compilation.

--
Claudio

Mike Carlton wrote:
> I have the same problem with an outdated libopt_connbytes.c
> 
> The latest snapshot
> ftp://ftp.netfilter.org/pub/iptables/snapshot/iptables-1.3.0-20041114.tar.bz2
> as well as the most recent browsable version I can find
> http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/trunk/iptables/extensions/libipt_connbytes.c?rev=3071&view=markup
> 
> are both old.  
> 
> Can you give us a link to the current subversion version you refer to?
> 
> Thanks,
> --Mike Carlton
> 
> 
> On Tue, 9 Nov 2004 10:04:22 +0100, Harald Welte <laforge@netfilter.org> wrote:
> 
>>On Tue, Nov 09, 2004 at 02:17:25AM -0300, koba@koba.com.ar wrote:
>>
>>>Hello,
>>>      I've been trying to get the connbytes module working but apparently
>>>      the CVS/SVN libipt_connbytes.c is outdated (for example it uses sinfo->from
>>>instead of sinfo->count.from). If you've been mantaining it, can you
>>>send me your latest version?
>>
>>Which particular version of ipt_connbytes are you talking about?
>>
>>at least the 2.6.x version from subversion appears to use 'count.from'
>>consistently.
>>
>>I don't have anything else than current subversion.
>>
>>--
>>- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
>>============================================================================
>>  "Fragmentation is like classful addressing -- an interesting early
>>   architectural error that shows how much experimentation was going
>>   on while IP was being designed."                    -- Paul Vixie
>>
>>
>>
