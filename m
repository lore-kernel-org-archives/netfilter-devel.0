From: Gilles Kerdoncuff <gkerdoncuff.ext@orange-ftgroup.com>
Subject: Re: [PATCH] Update SNMP basic for full IP address NAT
Date: Thu, 23 Nov 2006 17:09:13 +0100
Message-ID: <4565C7A9.1040500@orange-ftgroup.com>
References: <3418F3471F1CA4409901547349FFAE2E05A05077@FTRDMEL2.rd.francetele		com.fr>
	<455AB76C.9050603@trash.net> <455C7E46.6080404@orange-ftgroup.com>
	<4565A6CC.1090404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4565A6CC.1090404@trash.net>
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
> Gilles Kerdoncuff wrote:
>   
>> ** I understand that you'd like to keep the /8 behavior, yet, something
>> still troubles me with the current ip_nat_snmp_basic.c file :
>>
>> The from/to fields of the oct1_map structure are filled-in by calling
>> the NOCT1 (0xFF mask) macro on the tuple IP.
>> Which means that on a 192.168.1.x address, it takes the x part.
>>     
>
> I'm confused - you seem to be right, but quick testing shows it behaves
> correctly and takes the 192 part.
>
>   
This makes things clear. This is one of those little/big endian problems :
I'm using this module on a MIPS platform, you probably tested it on an 
Intel architecture

If you look at ip_conntrack_ftp.c, it uses ntohl routine when extracting 
the tuple IP. This is the way it should be done.

In the SNMP module, add ntohl after the
    map.to = NOCT1(
and
    map.from = NOCT1(
code lines
Run your quick test again, you will see that the bug is there !

I will fix that in my updated patch.


>> ** Anyway, if any use case for the /8 behavior exists, I don't mind
>> adding a parameter to test only the first 8,16,24 or 32 bits of the
>> address, keeping /8 as a default.
>>     
>
> Please do so. But why only 8,16,24,32? I don't believe allowing
> any prefix len will be harder to do.
>   
Ok, I'll do so as soon as I can find a few hours to code and test it.
Thanks a lot.

Gilles.

 
