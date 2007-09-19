From: "Lirui ZHU" <lirui.zhu@visiongateway.net>
Subject: FYI: Solved a dynamic linking loader issues with iptables,libiptc
Date: Wed, 19 Sep 2007 17:51:51 +1000
Message-ID: <000501c7fa91$f09a1460$6500000a@lirui>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi, Jseper:

I have a problem which you have solved.=20
Error:Couldn't load target 'standard': =
/lib/iptc/iptables/libipt_standard.so:undefined symbol: =
register_target.From:I use Java(JNI) to call iptables-standalone.c's =
do_command with libiptc.I use following command to compile.gcc -Wall =
-Wunused -rdynamic -DIPTABLES_VERSION=3D\"1.3.6\" iptc_MediatorImpl.c -o =
libiptc_MediatorImpl.so -shared -I$JAVA_HOME/include =
-I$JAVA_HOME/include/linux/usr/lib/iptables.o /usr/lib/libiptc.a =
-ldlThanks a lot.lirui
