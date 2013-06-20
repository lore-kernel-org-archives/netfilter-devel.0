From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] test: add testbench for XML
Date: Thu, 20 Jun 2013 21:02:34 +0200
Message-ID: <20130620190234.GA13710@localhost>
References: <20130618205857.1600.52812.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52217 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965764Ab3FTTCl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:02:41 -0400
Content-Disposition: inline
In-Reply-To: <20130618205857.1600.52812.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

Some comments below, mostly related to the XML output not the
list of test case itself.

On Tue, Jun 18, 2013 at 10:58:57PM +0200, Arturo Borrero Gonzalez wrote:
> This patch add a testbench for XML parsing, which may be extended to also test JSON.
> 
> To use it:
>  $ cd test/
>  $ make nft-parsing-test
>  $ ./nft-parsing-test xmlfiles/
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  test/Makefile.am                 |    6 ++
>  test/nft-parsing-test.c          |  125 ++++++++++++++++++++++++++++++++++++++
>  test/xmlfiles/chain1.xml         |   11 +++
>  test/xmlfiles/chain2.xml         |   11 +++
>  test/xmlfiles/chain3.xml         |   11 +++
>  test/xmlfiles/rule_bitwise.xml   |   25 ++++++++
>  test/xmlfiles/rule_byteorder.xml |   13 ++++
>  test/xmlfiles/rule_cmp.xml       |   16 +++++
>  test/xmlfiles/rule_counter.xml   |   10 +++
>  test/xmlfiles/rule_ct.xml        |   11 +++
>  test/xmlfiles/rule_exthdr.xml    |   12 ++++
>  test/xmlfiles/rule_immediate.xml |   31 +++++++++
>  test/xmlfiles/rule_limit.xml     |   10 +++
>  test/xmlfiles/rule_log.xml       |   12 ++++
>  test/xmlfiles/rule_lookup.xml    |   11 +++
>  test/xmlfiles/rule_match.xml     |   10 +++
>  test/xmlfiles/rule_meta.xml      |   10 +++
>  test/xmlfiles/rule_nat.xml       |   22 +++++++
>  test/xmlfiles/rule_payload.xml   |   12 ++++
>  test/xmlfiles/rule_target.xml    |   10 +++
>  test/xmlfiles/table1.xml         |    6 ++
>  test/xmlfiles/table2.xml         |    6 ++
>  22 files changed, 391 insertions(+)
>  create mode 100644 test/Makefile.am
>  create mode 100644 test/nft-parsing-test.c
>  create mode 100644 test/xmlfiles/chain1.xml
>  create mode 100644 test/xmlfiles/chain2.xml
>  create mode 100644 test/xmlfiles/chain3.xml
>  create mode 100644 test/xmlfiles/rule_bitwise.xml
>  create mode 100644 test/xmlfiles/rule_byteorder.xml
>  create mode 100644 test/xmlfiles/rule_cmp.xml
>  create mode 100644 test/xmlfiles/rule_counter.xml
>  create mode 100644 test/xmlfiles/rule_ct.xml
>  create mode 100644 test/xmlfiles/rule_exthdr.xml
>  create mode 100644 test/xmlfiles/rule_immediate.xml
>  create mode 100644 test/xmlfiles/rule_limit.xml
>  create mode 100644 test/xmlfiles/rule_log.xml
>  create mode 100644 test/xmlfiles/rule_lookup.xml
>  create mode 100644 test/xmlfiles/rule_match.xml
>  create mode 100644 test/xmlfiles/rule_meta.xml
>  create mode 100644 test/xmlfiles/rule_nat.xml
>  create mode 100644 test/xmlfiles/rule_payload.xml
>  create mode 100644 test/xmlfiles/rule_target.xml
>  create mode 100644 test/xmlfiles/table1.xml
>  create mode 100644 test/xmlfiles/table2.xml
> 
> diff --git a/Makefile.am b/Makefile.am
> index 6999f51..e035ea1 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -2,8 +2,8 @@ include $(top_srcdir)/Make_global.am
>  
>  ACLOCAL_AMFLAGS = -I m4
>  
> -SUBDIRS = src include examples
> -DIST_SUBDIRS = src include examples
> +SUBDIRS = src include examples test
> +DIST_SUBDIRS = src include examples test

Please, don't include the test directory in DIST_SUBDIRS. I prefer not
to distribute the tests in the tarball.

>  pkgconfigdir = $(libdir)/pkgconfig
>  pkgconfig_DATA = libnftables.pc
> diff --git a/configure.ac b/configure.ac
> index 0eec5bd..eaf3bb8 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -38,5 +38,5 @@ regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
>  	-Wformat=2 -pipe"
>  AC_SUBST([regular_CPPFLAGS])
>  AC_SUBST([regular_CFLAGS])
> -AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libnftables/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile libnftables.pc doxygen.cfg])
> +AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libnftables/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile test/Makefile libnftables.pc doxygen.cfg])
>  AC_OUTPUT
> diff --git a/examples/chain.xml b/examples/chain.xml
> deleted file mode 100644
> index 01ccb85..0000000
> --- a/examples/chain.xml
> +++ /dev/null
> @@ -1,11 +0,0 @@
> -<chain name="test" handle="0" bytes="59" packets="1" version="0">
> -	<properties>
> -		<type>filter</type>
> -		<table>filter</table>
> -		<prio>1</prio>
> -		<use>0</use>
> -		<hooknum>4</hooknum>

We should convert hooknum to make it human readable. You can use this
array to achieve it:

static const char *hooknum2str_array[NF_INET_NUMHOOKS] = {
        [NF_INET_PRE_ROUTING] = "NF_INET_PRE_ROUTING",
        [NF_INET_LOCAL_IN] = "NF_INET_LOCAL_IN",
        [NF_INET_FORWARD] = "NF_INET_FORWARD",
        [NF_INET_LOCAL_OUT] = "NF_INET_LOCAL_OUT",
        [NF_INET_POST_ROUTING] = "NF_INET_POST_ROUTING",
};

> -		<policy>1</policy>

Same thing here, this should be converted to NF_ACCEPT = "accept" and
NF_DROP = "drop". You will have to change the parser as well, yes.

> -		<family>10</family>

Convert to AF_INET = ip, AF_INET6 = ip6, AF_BRIDGE = bridge and 0 =
arp.

> -	</properties>
> -</chain>
> diff --git a/examples/rule.xml b/examples/rule.xml
> deleted file mode 100644
> index b1de25a..0000000
> --- a/examples/rule.xml
> +++ /dev/null
> @@ -1,85 +0,0 @@
> -<?xml version="1.0"?>
> -<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> -  <rule_flags>0</rule_flags>
> -  <flags>127</flags>

Hm, I decided to get rid of these internal flags already right? They
are not exported anymore.

> -  <compat_flags>0</compat_flags>
> -  <compat_proto>0</compat_proto>

Please, only print these two if:

compat_flags != 0 || compat_proto != 0

> -  <expr type="meta">
> -    <dreg>1</dreg>
> -    <key>4</key>
> -  </expr>
> -  <expr type="cmp">
> -    <sreg>1</sreg>
> -    <op>eq</op>
> -    <cmpdata>
> -      <data_reg type="value">
> -        <len>1</len>
> -        <data0>0x04000000</data0>
> -      </data_reg>
> -    </cmpdata>
> -  </expr>
> -  <expr type="payload">
> -    <dreg>1</dreg>
> -    <base>1</base>
> -    <offset>12</offset>
> -    <len>4</len>
> -  </expr>
> -  <expr type="cmp">
> -    <sreg>1</sreg>
> -    <op>eq</op>
> -    <cmpdata>
> -      <data_reg type="value">
> -        <len>1</len>
> -        <data0>0x96d60496</data0>
> -      </data_reg>
> -    </cmpdata>
> -  </expr>
> -  <expr type="payload">
> -    <dreg>1</dreg>
> -    <base>1</base>
> -    <offset>16</offset>
> -    <len>4</len>
> -  </expr>
> -  <expr type="cmp">
> -    <sreg>1</sreg>
> -    <op>eq</op>
> -    <cmpdata>
> -      <data_reg type="value">
> -        <len>1</len>
> -        <data0>0x96d60329</data0>
> -      </data_reg>
> -    </cmpdata>
> -  </expr>
> -  <expr type="payload">
> -    <dreg>1</dreg>
> -    <base>1</base>
> -    <offset>9</offset>
> -    <len>1</len>
> -  </expr>
> -  <expr type="cmp">
> -    <sreg>1</sreg>
> -    <op>eq</op>
> -    <cmpdata>
> -      <data_reg type="value">
> -        <len>1</len>
> -        <data0>0x06000000</data0>
> -      </data_reg>
> -    </cmpdata>
> -  </expr>
> -  <expr type="match">
> -    <name>state</name>
> -    <rev>0</rev>
> -   <info>
> -    </info>
> -  </expr>
> -  <expr type="counter">
> -    <pkts>123123</pkts>
> -    <bytes>321321</bytes>
> -  </expr>
> -  <expr type="target">
> -    <name>LOG</name>
> -    <rev>0</rev>
> -    <info>
> -    </info>
> -  </expr>
> -</rule>
> diff --git a/examples/table.xml b/examples/table.xml
> deleted file mode 100644
> index a397d52..0000000
> --- a/examples/table.xml
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -<table name="filter" version="0">
> -	<properties>
> -		<family>2</family>
> -		<table_flags>0</table_flags>
> -	</properties>
> -</table>
> diff --git a/test/Makefile.am b/test/Makefile.am
> new file mode 100644
> index 0000000..6941c3c
> --- /dev/null
> +++ b/test/Makefile.am
> @@ -0,0 +1,6 @@
> +include $(top_srcdir)/Make_global.am
> +
> +check_PROGRAMS = nft-parsing-test
> +
> +nft_parsing_test_SOURCES = nft-parsing-test.c
> +nft_parsing_test_LDADD = ../src/libnftables.la ${LIBMNL_LIBS} ${LIBXML_LIBS}
> diff --git a/test/nft-parsing-test.c b/test/nft-parsing-test.c
> new file mode 100644
> index 0000000..dc0ab85
> --- /dev/null
> +++ b/test/nft-parsing-test.c
> @@ -0,0 +1,125 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <dirent.h>
> +
> +#include <mxml.h>
> +
> +#include <libmnl/libmnl.h> /*nlmsghdr*/
> +#include <libnftables/table.h>
> +#include <libnftables/chain.h>
> +#include <libnftables/rule.h>
> +
> +static int test_xml(const char *filename)
> +{
> +	int ret = -1;
> +	struct nft_table *t = NULL;
> +	struct nft_chain *c = NULL;
> +	struct nft_rule *r = NULL;
> +	FILE *fp;
> +	mxml_node_t *tree = NULL;;
> +	char *xml = NULL;
> +
> +	fp = fopen(filename, "r");
> +	tree = mxmlLoadFile(NULL, fp, MXML_NO_CALLBACK);
> +	fclose(fp);
> +
> +	xml = mxmlSaveAllocString(tree, MXML_NO_CALLBACK);
> +	if (xml == NULL)
> +		return -1;
> +
> +	if (tree == NULL)
> +		return -1;
> +
> +	/* Check what parsing should be done */
> +	if (strcmp(tree->value.opaque, "table") == 0) {
> +		t = nft_table_alloc();
> +		if (t != NULL) {
> +			if (nft_table_parse(t, NFT_TABLE_PARSE_XML, xml) == 0)
> +				ret = 0;
> +
> +			nft_table_free(t);
> +		}
> +	} else if (strcmp(tree->value.opaque, "chain") == 0) {
> +		c = nft_chain_alloc();
> +		if (c != NULL) {
> +			if (nft_chain_parse(c, NFT_CHAIN_PARSE_XML, xml) == 0)
> +				ret = 0;
> +
> +			nft_chain_free(c);
> +		}
> +	} else if (strcmp(tree->value.opaque, "rule") == 0) {
> +		r = nft_rule_alloc();
> +		if (r != NULL) {
> +			if (nft_rule_parse(r, NFT_RULE_PARSE_XML, xml) == 0)
> +				ret = 0;
> +
> +			nft_rule_free(r);
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static int test_json(const char *filename)
> +{
> +	/* XXX parse file JSON file, in case of failure return -1 */
> +	return -1;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	DIR *d;
> +	struct dirent *dent;
> +
> +	if (argc != 2) {
> +		fprintf(stderr, "Usage: %s <directory>\n", argv[0]);
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	d = opendir(argv[1]);
> +	if (d == NULL) {
> +		perror("opendir");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	char *path = malloc(sizeof(argv[1]));
> +	char *filewpath = malloc(sizeof(path)+4096);
> +	strcpy(path, argv[1]);
> +
> +	if (path[strlen(path)-1] != '/')
> +		strcat(path, "/");
> +
> +
> +	while ((dent = readdir(d)) != NULL) {
> +		int len = strlen(dent->d_name);
> +
> +		if (strcmp(dent->d_name, ".") == 0 ||
> +		    strcmp(dent->d_name, "..") == 0)
> +			continue;
> +
> +		strcpy(filewpath, path);
> +		strcat(filewpath, dent->d_name);

Better use snprintf, strcat is sloppy.

        char path[PATH_MAX];

        snprintf(path, sizeof(path), "%s/%s", argv[1], dent->d_name);

Pass it to test_xml(file)

> +		if (strcmp(&dent->d_name[len-5], ".json") == 0) {
> +			printf("parsing json file %s ..\t", filewpath);
> +			if (test_json(filewpath) < 0)
> +				printf("FAILED\n");
> +			else
> +				printf("OK\n");
> +		}
> +
> +		if (strcmp(&dent->d_name[len-4], ".xml") == 0) {
> +			printf("parsing xml file %s ..\t", filewpath);
> +			if (test_xml(filewpath) < 0)
> +				printf("FAILED\n");
> +			else
> +				printf("OK\n");
> +		}
> +	}
> +
> +	free(path);
> +	free(filewpath);
> +	closedir(d);
> +	return 0;
> +}
> diff --git a/test/xmlfiles/chain1.xml b/test/xmlfiles/chain1.xml
> new file mode 100644
> index 0000000..7b23904
> --- /dev/null
> +++ b/test/xmlfiles/chain1.xml
> @@ -0,0 +1,11 @@
> +<chain name="test" handle="0" bytes="0" packets="0" version="0">
> +	<properties>
> +		<type>filter</type>
> +		<table>filter</table>
> +		<prio>0</prio>
> +		<use>0</use>
> +		<hooknum>0</hooknum>
> +		<policy>0</policy>
> +		<family>2</family>
> +	</properties>
> +</chain>
> diff --git a/test/xmlfiles/chain2.xml b/test/xmlfiles/chain2.xml
> new file mode 100644
> index 0000000..01ccb85
> --- /dev/null
> +++ b/test/xmlfiles/chain2.xml
> @@ -0,0 +1,11 @@
> +<chain name="test" handle="0" bytes="59" packets="1" version="0">
> +	<properties>
> +		<type>filter</type>
> +		<table>filter</table>
> +		<prio>1</prio>
> +		<use>0</use>
> +		<hooknum>4</hooknum>
> +		<policy>1</policy>
> +		<family>10</family>
> +	</properties>
> +</chain>
> diff --git a/test/xmlfiles/chain3.xml b/test/xmlfiles/chain3.xml
> new file mode 100644
> index 0000000..31e7142
> --- /dev/null
> +++ b/test/xmlfiles/chain3.xml
> @@ -0,0 +1,11 @@
> +<chain name="foo" handle="100" bytes="59264154979" packets="2548796325" version="0">
> +	<properties>
> +		<type>foo</type>

Please, I prefer realistic tests:

Possible types are the following strings: filter, route, nat

> +		<table>nat</table>
> +		<prio>123</prio>
> +		<use>321</use>
> +		<hooknum>123</hooknum>
> +		<policy>123</policy>
> +		<family>123</family>

This policy and family are not realistic either ;-)

> +	</properties>
> +</chain>
> diff --git a/test/xmlfiles/rule_bitwise.xml b/test/xmlfiles/rule_bitwise.xml
> new file mode 100644
> index 0000000..0501c6c
> --- /dev/null
> +++ b/test/xmlfiles/rule_bitwise.xml
> @@ -0,0 +1,25 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="bitwise">
> +    <sreg>1</sreg>
> +    <dreg>12</dreg>

We only have NFT_REG_MAX registers.

> +    <mask>
> +      <data_reg type="value">
> +        <len>1</len>
> +        <data0>0x04000000</data0>
> +      </data_reg>
> +    </mask>
> +    <xor>
> +      <data_reg type="value">
> +        <len>4</len>
> +        <data0>0xfaceb00c</data0>
> +        <data1>0xc1cac1ca</data1>
> +        <data2>0xcafecafe</data2>
> +        <data3>0xdeadbeef</data3>

The mask and xor has to use the same number of data registers.

> +      </data_reg>
> +    </xor>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_byteorder.xml b/test/xmlfiles/rule_byteorder.xml
> new file mode 100644
> index 0000000..3b5d64d
> --- /dev/null
> +++ b/test/xmlfiles/rule_byteorder.xml
> @@ -0,0 +1,13 @@
> +<rule family="1" table="test" chain="test" handle="1000" version="0">
> +  <rule_flags>123</rule_flags>
> +  <flags>123</flags>
> +  <compat_flags>123</compat_flags>
> +  <compat_proto>123</compat_proto>
> +  <expr type="byteorder">
> +	<sreg>123</sreg>
> +	<dreg>321</dreg>

wrong register numbers.

> +	<op>111</op>

Bad operation. Possible are defined by NFT_BYTEORDER_*

> +	<len>15</len>
> +	<size>15</size>

also fix this.

> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_cmp.xml b/test/xmlfiles/rule_cmp.xml
> new file mode 100644
> index 0000000..582b127
> --- /dev/null
> +++ b/test/xmlfiles/rule_cmp.xml
> @@ -0,0 +1,16 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="cmp">
> +    <sreg>1</sreg>
> +    <op>eq</op>

oh, you're using string here, good :-)

> +    <cmpdata>
> +      <data_reg type="value">
> +        <len>1</len>
> +        <data0>0x04000000</data0>
> +      </data_reg>
> +    </cmpdata>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_counter.xml b/test/xmlfiles/rule_counter.xml
> new file mode 100644
> index 0000000..bb71013
> --- /dev/null
> +++ b/test/xmlfiles/rule_counter.xml
> @@ -0,0 +1,10 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="counter">
> +    <pkts>123123</pkts>
> +    <bytes>321321</bytes>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_ct.xml b/test/xmlfiles/rule_ct.xml
> new file mode 100644
> index 0000000..c993ae5
> --- /dev/null
> +++ b/test/xmlfiles/rule_ct.xml
> @@ -0,0 +1,11 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="ct">
> +    <dreg>1555555</dreg>

no possible.

> +    <dir>15</dir>

IIRC, two possible strings: 0 = original, 1 = reply

> +    <key>15</key>

keys are defined in nft_ct_keys.

> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_exthdr.xml b/test/xmlfiles/rule_exthdr.xml
> new file mode 100644
> index 0000000..0abeb3c
> --- /dev/null
> +++ b/test/xmlfiles/rule_exthdr.xml
> @@ -0,0 +1,12 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="exthdr">
> +    <dreg>123</dreg>

fix.

> +    <type>15</type>

Possibilities are defined by: nft_exthdr_attributes

> +    <offset>123</offset>
> +    <len>321</len>

Oh, we cannot get more than 2^8.

It's good if you start looking at: net/netfilter/nft_exthdr.c

> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_immediate.xml b/test/xmlfiles/rule_immediate.xml
> new file mode 100644
> index 0000000..a566ca5
> --- /dev/null
> +++ b/test/xmlfiles/rule_immediate.xml
> @@ -0,0 +1,31 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="immediate">
> +    <dreg>1</dreg>
> +    <immdata>
> +      <data_reg type="value">
> +        <len>1</len>
> +	<data0>0xaabbccdd</data0>

Lenghs says 1 byte, but I can see way more stuff there.

A good way to generate realistic test cases is to add rules with nft
and then use libnftables examples/ to obtain the output in XML. So you
don't need to make it up.

> +      </data_reg>
> +    </immdata>
> +  </expr>
> +  <expr type="immediate">
> +    <dreg>2</dreg>
> +    <immdata>
> +      <data_reg type="verdict">
> +        <verdict>1</verdict>
> +      </data_reg>
> +    </immdata>
> +  </expr>
> +  <expr type="immediate">
> +    <dreg>3</dreg>
> +    <immdata>
> +      <data_reg type="chain">
> +        <chain>testchain</chain>
> +      </data_reg>
> +    </immdata>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_limit.xml b/test/xmlfiles/rule_limit.xml
> new file mode 100644
> index 0000000..926aa0e
> --- /dev/null
> +++ b/test/xmlfiles/rule_limit.xml
> @@ -0,0 +1,10 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="limit">
> +    <rate>123123</rate>
> +    <depth>321321</depth>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_log.xml b/test/xmlfiles/rule_log.xml
> new file mode 100644
> index 0000000..5471fee
> --- /dev/null
> +++ b/test/xmlfiles/rule_log.xml
> @@ -0,0 +1,12 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="log">
> +    <group>123123121</group>

possible groups are 0-65535.

> +    <snaplen>4000000</snaplen>
> +    <qthreshold>1222222</qthreshold>
> +    <prefix>prefixtest</prefix>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_lookup.xml b/test/xmlfiles/rule_lookup.xml
> new file mode 100644
> index 0000000..ee47068
> --- /dev/null
> +++ b/test/xmlfiles/rule_lookup.xml
> @@ -0,0 +1,11 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="lookup">
> +    <sreg>123</sreg>
> +    <dreg>123</dreg>

bad registers.

> +    <set>set_name_test</set>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_match.xml b/test/xmlfiles/rule_match.xml
> new file mode 100644
> index 0000000..fdc28f5
> --- /dev/null
> +++ b/test/xmlfiles/rule_match.xml
> @@ -0,0 +1,10 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="match">
> +    <name>state</name>
> +    <rev>0</rev>

don't export the rev number, I don't think it's meaningful to the
application.

> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_meta.xml b/test/xmlfiles/rule_meta.xml
> new file mode 100644
> index 0000000..3c14bad
> --- /dev/null
> +++ b/test/xmlfiles/rule_meta.xml
> @@ -0,0 +1,10 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="meta">
> +    <dreg>1</dreg>
> +    <key>4</key>

Keys for meta are defined by nft_meta_keys.

> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_nat.xml b/test/xmlfiles/rule_nat.xml
> new file mode 100644
> index 0000000..868be50
> --- /dev/null
> +++ b/test/xmlfiles/rule_nat.xml
> @@ -0,0 +1,22 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="nat">
> +    <sreg_addr_min>1</sreg_addr_min>
> +    <sreg_addr_max>1</sreg_addr_max>

These above are IPv4 / IPv6 addresses. Should be printable ini
human readable format, you probably use inet_ntop for output and
inet_pton for input.

> +    <sreg_proto_min>1</sreg_proto_min>
> +    <sreg_proto_max>1</sreg_proto_max>

max here is 2^16 as they are port numbers.

> +    <family>AF_INET6</family>

would be good to replace this by ip6.

> +    <type>NFT_NAT_DNAT</type>

and this by dnat.

> +  </expr>
> +  <expr type="nat">

The ipv4 part is asking for a new file, add rule_nat-ipv4.xml and
rule_nat-ipv6.xml

> +    <sreg_addr_min>1</sreg_addr_min>
> +    <sreg_addr_max>1</sreg_addr_max>
> +    <sreg_proto_min>1</sreg_proto_min>
> +    <sreg_proto_max>1</sreg_proto_max>
> +    <family>AF_INET</family>
> +    <type>NFT_NAT_SNAT</type>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_payload.xml b/test/xmlfiles/rule_payload.xml
> new file mode 100644
> index 0000000..bbbc84f
> --- /dev/null
> +++ b/test/xmlfiles/rule_payload.xml
> @@ -0,0 +1,12 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="payload">
> +    <dreg>1</dreg>
> +    <base>1</base>

Possible bases are defined by nft_payload_bases, use strings "link",
"network", "transport".

> +    <offset>12</offset>
> +    <len>4</len>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/rule_target.xml b/test/xmlfiles/rule_target.xml
> new file mode 100644
> index 0000000..a41d794
> --- /dev/null
> +++ b/test/xmlfiles/rule_target.xml
> @@ -0,0 +1,10 @@
> +<rule family="2" table="filter" chain="INPUT" handle="100" version="0">
> +  <rule_flags>0</rule_flags>
> +  <flags>127</flags>
> +  <compat_flags>0</compat_flags>
> +  <compat_proto>0</compat_proto>
> +  <expr type="target">
> +    <name>LOG</name>
> +    <rev>0</rev>
> +  </expr>
> +</rule>
> diff --git a/test/xmlfiles/table1.xml b/test/xmlfiles/table1.xml
> new file mode 100644
> index 0000000..a397d52
> --- /dev/null
> +++ b/test/xmlfiles/table1.xml
> @@ -0,0 +1,6 @@
> +<table name="filter" version="0">
> +	<properties>
> +		<family>2</family>
> +		<table_flags>0</table_flags>
> +	</properties>
> +</table>
> diff --git a/test/xmlfiles/table2.xml b/test/xmlfiles/table2.xml
> new file mode 100644
> index 0000000..de8e570
> --- /dev/null
> +++ b/test/xmlfiles/table2.xml
> @@ -0,0 +1,6 @@
> +<table name="nat" version="0">
> +	<properties>
> +		<family>10</family>
> +		<table_flags>123</table_flags>

The only table flag is defined by enum nft_table_flags.

> +	</properties>
> +</table>
> 

Please, send me patches to address those and then resend this patch
once all of them has been resolved.

Thanks.
