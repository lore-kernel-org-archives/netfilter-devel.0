From: laurent.ml@linuxfr.org
Subject: kernel 2.5 and patch-o-matic
Date: Sun, 24 Nov 2002 15:38:33 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <wazza.87znrz0yh2.fsf@message.id>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I'm wondering how to use patch-o-matic(cvs) with kernel 2.5.
I've tested the runme from patch-o-matic_2.5 (cvs). it doesn't work.
I've tested with the last patch posted in that mailing-list, it
doesn't work either.
Could you tell me where I can find a working runme or give me some advice ?

Thanks in advance.

<ERRORS>
/usr/src/linux-2.5.49/../737c36473fcb3498c35a0412415654394916b91f187dc2606a1863b07ae6c057/net/ipv6/netfilter/Config.help
or /usr/src/linux-2.5.49/../737c36473fcb3498c35a0412415654394916b91f187dc2606a1863b07ae6c057/Documentation/Configure.help
fgrep: /usr/src/linux-2.5.49/../737c36473fcb3498c35a0412415654394916b91f187dc2606a1863b07ae6c057/net/ipv6/netfilter/Config.in: No such file or directory
Could not find place to slot in Config.in line
TEST FAILED: patch NOT applied.
</ERRORS>

-- 
Laurent
 
[sorry, I re-post with good headers]
