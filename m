From: "JooChul-Lee" <rune@etri.re.kr>
Subject: wrong getnum function name for reply of EPSV
Date: Sat, 19 Oct 2002 10:33:23 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <004201c2770f$83a66490$b470fe81@runic>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi. folks

While I am reading ip_conntrack_ftp codes I found some typo. :)

The function name of getnum for reply of EPSV should be
"try_epsv_response" I think. (not try_espv_response)

In my guess, this is some kind of mistake (just typo) ;-)

regards.

-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
JooChul, Lee (ETRI)
Electronics and Telecommunications Research Institute.
161 Kajong-dong, Yusong-Gu, TAEJON, 305-350, KOREA
E-mail : rune@etri.re.kr
Tel : +82-042-860-1021
-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- 
