From: Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH 0/2] Add IPv6 support
Date: Tue, 19 Feb 2008 16:03:33 +0100
Message-ID: <47BAEFC5.30702@trash.net>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net><3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com><1201303354.2909.1.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CA7F@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802080126020.25157@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CB14@orsmsx423.amr.corp.intel.com><1202494854.2895.11.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A85D069@orsmsx423.amr.corp.intel.com><1202664082.2907.5.camel@localhost.localdomain>
	<3F25FE8C477E9E4FB3D42C2FF937C08A85D440@orsmsx423.amr.corp.intel.com>
	<3F25FE8C477E9E4FB3D42C2FF937C08A897BDA@orsmsx423.amr.corp.intel.com>
	<Pine.LNX.4.64.0802120333400.29955@fbirervta.pbzchgretzou.qr>
	<3F25FE8C477E9E4FB3D42C2FF937C08A8D0909@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>,
	netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Tseng, Kuo-Lang" <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <3F25FE8C477E9E4FB3D42C2FF937C08A8D0909-7XlYjKTK0pNQxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ebtables-devel>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Tseng, Kuo-Lang wrote:
> According to
> http://article.gmane.org/gmane.linux.network.bridge.ebtables.devel/719,
> I need to add required functions into userspace ebtables program and
> bridge-nf kernel module for parsing and matching on IPv6 header fields
> address, traffic class, IP protocol, and layer-4 port ids. 
> 
> Signed-off-by: Kuo-lang Tseng <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


I'll queue this for 2.6.26 if Bart is fine with these patches.

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
