From: Kiran Kumar <immidi_kiran@yahoo.com>
Subject: Re: Netfilter hook! Insert error (insmod)
Date: Tue, 30 Mar 2004 19:46:11 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331034611.86586.qmail@web14001.mail.yahoo.com>
References: <20040330034954.13321.qmail@web41302.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tuan nguyen hoang anh <nguyen_hoang_anh_tuan@yahoo.com>,
  netfilter-devel@lists.netfilter.org
In-Reply-To: <20040330034954.13321.qmail@web41302.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--- Tuan nguyen hoang anh
<nguyen_hoang_anh_tuan@yahoo.com> wrote:
> Hi, i'm writting a netfilter hook module. I compiled
> it successfull but when i insert it into kernel then
> it occurs errors following:
> 
> "unresolved symbol nf_register_hook"
> "unresolved symbol nf_unregister_hook"

modversions related problem? 
what is the kernel version?


=====
Regards,
Kiran Kumar Immidi

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
