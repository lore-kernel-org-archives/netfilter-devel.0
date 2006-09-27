From: "James D. Nurmi" <jdnurmi+nfdev@gmail.com>
Subject: Patch: nfqnl_mangle skb_trim
Date: Wed, 27 Sep 2006 17:31:36 +0200
Message-ID: <a1f5b31e0609270831o719e39f9r677408eeb993fc73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_40579_5641920.1159371096269"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

------=_Part_40579_5641920.1159371096269
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I've got some code very dependant on nfnetlink_queue, and turned up a
large number of warns coming from skb_trim.  While it's quite possibly
my code, having not seen it on older kernels made me a bit suspect.

Anyhow, based on some googling I turned up this thread:
http://lkml.org/lkml/2006/8/13/56

And believe the issue to be related, so attached is a small patch to
the kernel -- not sure if this is completely correct, but for anyone
else hitting the WARN_ON(1) in skbuff.h, it might be helpful..

Cheers,

James

------=_Part_40579_5641920.1159371096269
Content-Type: application/octet-stream; name="fix_skb_trim.2.6.18-patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="fix_skb_trim.2.6.18-patch"
X-Attachment-Id: f_eslvltuk

LS0tIG5ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rX3F1ZXVlLmMub3JpZwkyMDA2LTA5LTI3IDA4OjIz
OjE4LjAwMDAwMDAwMCAtMDcwMAorKysgbmV0L25ldGZpbHRlci9uZm5ldGxpbmtfcXVldWUuYwky
MDA2LTA5LTI3IDA4OjA4OjUyLjAwMDAwMDAwMCAtMDcwMApAQCAtNjIzLDcgKzYyMyw3IEBACiAK
IAlkaWZmID0gZGF0YV9sZW4gLSBlLT5za2ItPmxlbjsKIAlpZiAoZGlmZiA8IDApCi0JCXNrYl90
cmltKGUtPnNrYiwgZGF0YV9sZW4pOworCQlwc2tiX3RyaW0oZS0+c2tiLCBkYXRhX2xlbik7CiAJ
ZWxzZSBpZiAoZGlmZiA+IDApIHsKIAkJaWYgKGRhdGFfbGVuID4gMHhGRkZGKQogCQkJcmV0dXJu
IC1FSU5WQUw7Cg==
------=_Part_40579_5641920.1159371096269--
