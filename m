From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: 12_contrack_nat_dependency.patch
Date: 25 Mar 2003 23:18:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1048630711.14738.71.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Rusty,

I have a question about the 12_contrack_nat_dependency.patch in
p-o-m/pending...

The patch you sent Harald was for 2.5, will a similar patch work for
2.4? I've backported it and it compiles but I can't really test it.

It looks like it should work but I try to stay away from the module
voodoo...

-- 
/Martin
