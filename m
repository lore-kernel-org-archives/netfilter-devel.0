From: zhongyu <xxx@mail.goldenhope.com.cn>
Subject: Re: I write a oracle9 conntrack/nat module
Date: Fri, 26 Dec 2003 17:54:57 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8FF2CB02-3789-11D8-8C63-000A95B170F8@mail.goldenhope.com.cn>
References: <E8AD17E6-3682-11D8-B808-000A95B170F8@mail.goldenhope.com.cn> <20031226073257.GA9391@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0 (Apple Message framework v609)
Content-Type: text/plain; charset=ISO-2022-JP; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <20031226073257.GA9391@obroa-skai.de.gnumonks.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter dev <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

We did not have any document and just used tcpdump to look at the  
packet.
The oracle TNS protocol can work upon TCP/IP, IPC and named pipe. The
conn/nat patch can only work under tcp/ip. We tested it with Oracle9i  
and
Oracle8i. ethereal  had a parser for Oracle too, the package name is  
packet-tns.c.
2003.12.26, at 下午3:32, Harald Welte wrote:

> On Thu, Dec 25, 2003 at 10:34:48AM +0800, zhongyu wrote:
>> it worked for me :-)
>> anyone can download it from
>> http://www.goldenhope.com.cn/source/050_conntrack_nat_oracle.patch
>
> Thank you very much.  I would really like to integrate that module into
> netfilter's patch-o-matic repository.  However, apart from the
> 'MODULE_LICENSE' statement, the code does not clearly indicate that it
> is subiject to the GNU GPL license.
>
> If you could add a small header (like the one you can find on top of
> ip_nat_irc.c) to all .c files, that would be great.
>
> Also, may I ask how you learned about the details of the Oracle
> protocol?  Is there any documentation about that protocol online, (or
> available under an NDA?) - or did you have to reverse engineer the
> protocol format?
>
>> happy christmas everyone.
>
> Thank you, too.
>
> --  
> - Harald Welte <laforge@netfilter.org>              
> http://www.netfilter.org/
> ======================================================================= 
> =====
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
