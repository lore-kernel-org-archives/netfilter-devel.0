From: Andrea Rossato <mailing_list@istitutocolli.org>
Subject: Re: ECN target bug report
Date: Tue, 10 Dec 2002 19:30:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF632B7.2080108@istitutocolli.org>
References: <3DF1F442.806@istitutocolli.org> <3DF508CA.6000107@istitutocolli.org> <3DF52111.8080405@trash.net> <3DF6241A.9040404@istitutocolli.org> <3DF62FAF.9050908@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3DF62FAF.9050908@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> I thought calculating checksum for x and htons(x) should give me same 
> result, obiously that is wrong (which i learned after trying it out).
> For the first patch: *tcpflags are bitfields (position declared 
> dependant of endianess), so no htons here.
> For the second patch, it's working with or without, although i think the 
> correct way is with the patch:
> 
> u_int16_t diffs[2];
> diffs[0] = htons(iph->tos) ^ 0xFFFF;
> ...
> diffs[1] = htons(iph->tos);
> ...
> 
> iph->tos is of type u_int8_t. so no htons is necessary.


I know netiquette suggest not to send messages just to thank...but i 
spet the whole afternoon trying to understand when exactly host-to-net 
byte order translation was needed without results!
Now I've got it!!
Thanks,
andrea
