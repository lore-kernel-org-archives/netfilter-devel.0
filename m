From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Sun, 22 Aug 2004 00:30:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4127CCF9.2030505@trash.net>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Evgeniy Polyakov wrote:

>Fixed buffer overflow when reading rules from /proc file.
>
How is this supposed to fix it ?


                log("%s [%s]", f->genre, f->details);

-               count += sprintf(buf+count, "%s - %s[%s] : %s",
+               err = snprintf(buf+count, __count-count, "%s - %s[%s] : %s",
                                        f->genre, f->version,
                                        f->subtype, f->details);
-
+               if (err < 0)
+                       break;
+               else
+                       count += err;
                if (f->opt_num)
                {
                        loga(" OPT: ");

snprintf returns the number of characters written if n <= limit, otherwise
the number of characters that would have been generated for the given input,
but never < 0. You can also use vscnprintf to get the real number of bytes
written.

Regards
Patrick
