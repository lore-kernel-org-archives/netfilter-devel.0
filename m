From: zhongyu <xxx@mail.goldenhope.com.cn>
Subject: Re: the solution to synflood on netfilter (~{V#~}~{4+~}~{2(~})
Date: Fri, 26 Dec 2003 23:12:33 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <04EA80FA-37B6-11D8-936D-000A95B170F8@mail.goldenhope.com.cn>
Mime-Version: 1.0 (Apple Message framework v609)
Content-Type: text/plain; charset=ISO-2022-JP; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Resent-Message-Id: <EE58FD74-37B5-11D8-936D-000A95B170F8@mail.goldenhope.com.cn>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I will check it and paste it out in a few days.
Thanks everyone who will read my ugly code :-)

On 2003.12.26, at 下午4:18, Harald Welte wrote:

> On Fri, Dec 26, 2003 at 02:03:53PM +0800, zhongyu wrote:
>> There was a syn-cookie firewall patch for linux-2.2 ipchains.  I had
>> hacked it to 2.4 kernel.
>> But it was very dirty and had problems under bridge mode... Is there a
>> clean way to write a syn-cookie firewall in iptables framework?
>
> maybe you could publish your 'dirty' solution and we can see where the
> problems are, and how we could possibly modify it to become more clean.
>
> -- - Harald Welte <laforge@netfilter.org>              
> http://www.netfilter.org/
> ======================================================================= 
> =====
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
