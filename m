From: Patrick McHardy <kaber@trash.net>
Subject: Re: ECN target bug report
Date: Tue, 10 Dec 2002 19:17:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF62FAF.9050908@trash.net>
References: <3DF1F442.806@istitutocolli.org> <3DF508CA.6000107@istitutocolli.org> <3DF52111.8080405@trash.net> <3DF6241A.9040404@istitutocolli.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrea Rossato <mailing_list@istitutocolli.org>
In-Reply-To: <3DF6241A.9040404@istitutocolli.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Andrea Rossato wrote:

> Patrick McHardy wrote:
>
>> the first attached patch fixes the issue you reported (verified), 
>> altough i'm not entirely sure why ;).
>> the second one is untested but probably couldn't hurt neither.
>
>
> great patrick! faster then light!
>
> BTW, your second patch seems to imply that byte order is just a matter 
> of taste ;)
>
> iph and tcph should give little endian int on i386 arch, so tons 
> should be needed when writing to the sk_buff. but in computer 
> programming there are misteries a lawyar will never be able to grasp...

I thought calculating checksum for x and htons(x) should give me same 
result, obiously that is wrong (which i learned after trying it out).
For the first patch: *tcpflags are bitfields (position declared 
dependant of endianess), so no htons here.
For the second patch, it's working with or without, although i think the 
correct way is with the patch:

u_int16_t diffs[2];
diffs[0] = htons(iph->tos) ^ 0xFFFF;
...
diffs[1] = htons(iph->tos);
...

iph->tos is of type u_int8_t. so no htons is necessary.

Bye,
Patrick
