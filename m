From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: ipt_ACCOUNT accounting target released
Date: Tue, 13 Apr 2004 17:31:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404131731.02001.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello together,

I'm pleased to announce the first alpha release
of the high performance ipt_ACCOUNT target module.

You can find it here:
http://www.intra2net.com/opensource/ipt_account/

It's my first attempt at kernel/netfilter hacking,
so I'm open for any suggestions.

Two design issue still need to be resolved:
Is it possible to register a callback if a raw socket gets closed?
I want to free any possible left-over "handles".

Can I patch the "iptables" tool with the userspace part of the module
using pom-ng?

Best Regards,
Thomas Jarosch

-- 
Intra2net AG
Moempelgarder Weg 8
72072 Tuebingen
Germany

Tel: +49-7071-56510-0
Fax: +49-7071-56510-50
thomas.jarosch@intra2net.com
http://www.intra2net.com
