From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: Re: Re: can netfilter support sql*net?
Date: Fri, 14 Mar 2003 16:9:32 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303141605250.SM00856@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


>On Fri, Mar 07, 2003 at 10:29:22AM +0800, zhengchuanbo wrote:
>> 
>> we use oracle server, with sql*net dynamic port(not MTS). i tried to
>> find a patch for sql*net,but failed. is there any solution for
>> netfilter to support sql*net?
>
>I am not very familiar with the technical details on protocol level of
>oracle sql*net.  But if it uses a dynamic port, you would need a
>conntrack/nat helper.
>
>We are not aware of any development of such a helper for netfilter.
>
>btw: the list address is no longer @lists.samba.org, but
>     @lists.netfilter.org
>

  yes,sql*net just uses a dynamic port.  it works like this,1)the client connect to port 1521 on server,2)the server tell client a dynamic port,3)the client connect to the dynamic port.
  i think it's much more simple than ftp. i analized the ip_conntrack_ftp,and wanted to write a module to support that. but i'm a newbie on that,so i wish i could get some help on how to write such a module.
  thanks.

chuanbo zheng
	
	
>> chuanbo zheng
>
>-- 
>- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
>============================================================================
>Programming is like sex: One mistake and you have to support it your lifetime
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.0.6 (GNU/Linux)
>Comment: For info see http://www.gnupg.org
>
>iD8DBQE+a8yLXaXGVTD0i/8RAkHFAJ4uJi46qiC5peI4k7gtQPz5yLPhIQCffcUE
>QPx+osDjieq4ctobhCAE7z8=
>=SYCl
>-----END PGP SIGNATURE-----
